# -*- coding: utf-8 -*-
# Copyright: (c) 2018, Scott Buchanan <sbuchanan@ri.pn>
# Copyright: (c) 2016, Andrew Zenk <azenk@umn.edu> (lastpass.py used as starting point)
# Copyright: (c) 2018, Ansible Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

DOCUMENTATION = '''
    name: onepassword
    author:
      - Scott Buchanan (@scottsb)
      - Andrew Zenk (@azenk)
      - Sam Doran (@samdoran)
    requirements:
      - C(op) 1Password command line utility. See U(https://support.1password.com/command-line/)
    short_description: fetch field values from 1Password
    description:
      - C(onepassword) wraps the C(op) command line utility to fetch specific field values from 1Password.
    options:
      _terms:
        description: identifier(s) (UUID, name, or subdomain; case-insensitive) of item(s) to retrieve.
        required: True
      field:
        description: field to return from each matching item (case-insensitive).
        default: 'password'
      master_password:
        description: The password used to unlock the specified vault.
        aliases: ['vault_password']
      section:
        description: Item section containing the field to retrieve (case-insensitive). If absent will return first match from any section.
      domain:
        description: Domain of 1Password. Default is U(1password.com).
        version_added: 3.2.0
        default: '1password.com'
        type: str
      subdomain:
        description: The 1Password subdomain to authenticate against.
      username:
        description: The username used to sign in.
      secret_key:
        description: The secret key used when performing an initial sign in.
      vault:
        description: Vault containing the item to retrieve (case-insensitive). If absent will search all vaults.
      totp_code:
        description: Optional code used for full sign-in when two-factor authentication is enabled on the account.
    notes:
      - This lookup will use an existing 1Password session if one exists. If not, and you have already
        performed an initial sign in (meaning C(~/.op/config exists)), then only the C(master_password) is required.
        You may optionally specify C(subdomain) in this scenario, otherwise the last used subdomain will be used by C(op).
      - This lookup can perform an initial login by providing C(subdomain), C(username), C(secret_key), and C(master_password).
      - Due to the B(very) sensitive nature of these credentials, it is B(highly) recommended that you only pass in the minimal credentials
        needed at any given time. Also, store these credentials in an Ansible Vault using a key that is equal to or greater in strength
        to the 1Password master password.
      - This lookup stores potentially sensitive data from 1Password as Ansible facts.
        Facts are subject to caching if enabled, which means this data could be stored in clear text
        on disk or in a database.
      - Tested with C(op) version 0.5.3
'''

EXAMPLES = """
# These examples only work when already signed in to 1Password
- name: Retrieve password for KITT when already signed in to 1Password
  ansible.builtin.debug:
    var: lookup('community.general.onepassword', 'KITT')

- name: Retrieve password for Wintermute when already signed in to 1Password
  ansible.builtin.debug:
    var: lookup('community.general.onepassword', 'Tessier-Ashpool', section='Wintermute')

- name: Retrieve username for HAL when already signed in to 1Password
  ansible.builtin.debug:
    var: lookup('community.general.onepassword', 'HAL 9000', field='username', vault='Discovery')

- name: Retrieve password for HAL when not signed in to 1Password
  ansible.builtin.debug:
    var: lookup('community.general.onepassword'
                'HAL 9000'
                subdomain='Discovery'
                master_password=vault_master_password)

- name: Retrieve password for HAL when never signed in to 1Password
  ansible.builtin.debug:
    var: lookup('community.general.onepassword'
                'HAL 9000'
                subdomain='Discovery'
                master_password=vault_master_password
                username='tweety@acme.com'
                secret_key=vault_secret_key)
"""

RETURN = """
  _raw:
    description: field data requested
    type: list
    elements: str
"""

import errno
import json
import os
import platform

from subprocess import Popen, PIPE

from ansible.plugins.lookup import LookupBase
from ansible.errors import AnsibleLookupError
from ansible.module_utils.common.text.converters import to_bytes, to_text
from ansible.utils.display import Display

display = Display()

class OnePass(object):

    def __init__(self, path='/usr/local/bin/op'):
        self.cli_path = path
        self.config_file_path = os.path.expanduser('~/.config')
        display.vvvvv(self.config_file_path)
        self.logged_in = False
        self.token = None
        self.subdomain = None
        self.domain = None
        self.username = None
        self.secret_key = None
        self.master_password = None
        self.totp_code = None

    def get_token(self):
        display.vvv('entered get_token')
        # If the config file exists, assume an initial signin has taken place and try basic sign in
        if os.path.isfile(self.config_file_path):

            if not self.master_password:
                raise AnsibleLookupError('Unable to sign in to 1Password. master_password is required.')

            try:
                args = ['signin', '--raw', '--account {0}.{1}'.format(self.subdomain, self.domain)]
                if None not in [self.subdomain, self.domain]:
                    args += ['--account {0}.{1}'.format(self.subdomain, self.domain)]

                _, out, _ = self._run(args, command_input=to_bytes(self.master_password))
                self.token = out.strip()

            except AnsibleLookupError:
                self.full_login()

        else:
            # Attempt a full sign in since there appears to be no existing sign in
            self.full_login()

    def assert_account_added(self):
      display.vvv('entered assert_account_added')
      _, out, _ = self._run(['account', 'list', '--format=json'])

      accounts = json.loads(out)

      if len(accounts) == 0:
        display.vvv('assert_account_added found no accounts.  Returned: False')
        return False

      if None in [self.subdomain, self.domain, self.username]:
        display.vvv('assert_account_added at least one account.  Returned: True')
        return True

      for account in accounts:
        if account.url == '{0}.{1}'.format(self.subdomain, self.domain) and account.email == self.username:
          display.vvv('assert_account_added found specified account.  Returned: True')
          return True

      display.vvv('assert_account_added did not find specified account.  Returned: False')
      return False

    def assert_logged_in(self):
      display.vvv('entered assert_logged_in')
      rc = -1
      if not self.assert_account_added():
        self.logged_in = False
        self.full_login()
      elif None not in [self.subdomain, self.domain]:
        rc, _, _ = self._run(args=['account', 'get', '--account={0}.{1}'.format(self.subdomain, self.domain)], ignore_errors=True)
      else:
        rc, _, _ = self._run(args=['account', 'get'], ignore_errors=True)

      if rc == 0:
        self.logged_in = True
      el
      if not self.logged_in:
          self.get_token()

    def get_field(self, item_id, field, section=None, vault=None):
        args = ["item", "get", item_id, '--format=json', '--cache']
        if vault is not None:
            args += ['--vault={0}'.format(vault)]
        if not self.logged_in:
            args += [to_bytes('--session=') + self.token]

        if section is not None:
            args += ['--fields', 'label={0}.{1}'.format(section, field)]
        else:
            args += ['--fields', 'label={0}'.format(field)]

        _, output, _ = self._run(args)

        value = json.loads(output).get('value', None)

        return value

    def full_login(self):
        display.vvv('entered full_login')
        if None in [self.subdomain, self.username, self.secret_key, self.master_password]:
            raise AnsibleLookupError('Unable to perform initial sign in to 1Password. '
                                     'subdomain, username, secret_key, and master_password are required to perform initial sign in.')

        args = [
            'account', 'add',
            '--account={0}.{1}'.format(self.subdomain, self.domain),
            '--address={0}.{1}'.format(self.subdomain, self.domain),
            '--email={0}'.format(self.username),
            '--secret-key={0}'.format(self.secret_key),
            '--signin',
            '--raw'
        ]

        command_inputs = [ to_bytes(self.master_password) ]

        if self.totp_code is not None:
          command_inputs += [ to_bytes(self.totp_code) ]

        rc, out, _ = self._runs(args, command_input=command_inputs)
        display.vvvvv('rc={0}'.format(rc))
        self.get_token()

    def _runs(self, args, expected_rc=0, command_input=None, ignore_errors=False):
        try:
          command = [self.cli_path, '--config={0}'.format(self.config_file_path)] + args
          device_id = os.getenv('OP_DEVICE')

          p = Popen(command, stdout=PIPE, stderr=PIPE, stdin=PIPE, env={'OP_DEVICE': device_id})
          display.vvvvv(' '.join(command))
          p.stdin.writelines(command_input)
          out, err = p.communicate(input=None)
          display.vvvvv('stdout:')
          display.vvvvv(out.decode())
          display.vvvvv('stderr:')
          display.vvvvv(err.decode())
          rc = p.wait()
          if not ignore_errors and rc != expected_rc:
              raise AnsibleLookupError(to_text(err))
          return rc, out, err
        except OSError as e:
            if e.errno == errno.ENOENT:
                display.vvvvv(e.strerror)
                raise AnsibleLookupError("1Password CLI tool '%s' not installed in path on control machine" % self.cli_path)
            raise e

    def _run(self, args, expected_rc=0, command_input=None, ignore_errors=False):
        try:
          command = [self.cli_path, '--config={0}'.format(self.config_file_path)] + args
          display.vvvvv(' '.join(command))
          p = Popen(command, stdout=PIPE, stderr=PIPE, stdin=PIPE)
          out, err = p.communicate(input=command_input)
          rc = p.wait()
          if not ignore_errors and rc != expected_rc:
              raise AnsibleLookupError(to_text(err))
          return rc, out, err
        except OSError as e:
            if e.errno == errno.ENOENT:
                raise AnsibleLookupError("1Password CLI tool '%s' not installed in path on control machine" % self.cli_path)
            raise e


class LookupModule(LookupBase):

    def run(self, terms, variables=None, **kwargs):
        op = OnePass()

        field = kwargs.get('field', 'password')
        section = kwargs.get('section')
        vault = kwargs.get('vault')
        op.subdomain = kwargs.get('subdomain')
        op.domain = kwargs.get('domain', '1password.com')
        op.username = kwargs.get('username')
        op.secret_key = kwargs.get('secret_key')
        op.master_password = kwargs.get('master_password', kwargs.get('vault_password'))
        op.totp_code = kwargs.get('totp_code')
        op.assert_logged_in()

        values = []
        for term in terms:
            values.append(op.get_field(term, field, section, vault))
        return values
