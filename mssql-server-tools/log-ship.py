#!/usr/bin/env python3
import argparse
from jinja2 import Environment, FileSystemLoader
import os
import subprocess
import sys

sqlcmd = r'/opt/mssql-tools/bin/sqlcmd'

file_loader = FileSystemLoader('/scripts/templates')
env = Environment(loader=file_loader)

def createDatabase(args):
  template = env.get_template('create_database.sql.j2')
  query = template.render(database_name=args.database_name)
  print(query)
  if not args.is_dry_run:
    command = [sqlcmd, '-S', args.hostname, '-U', args.login, '-P', args.password, '-Q', query]
    process = subprocess.Popen(command,stdout=subprocess.PIPE)
    while True:
        output = process.stdout.readline()
        if process.poll() is not None and output == b'':
            break
        if output:
            print (output.strip().decode("utf-8"))
    retval = process.poll()
    exit(retval)


parser = argparse.ArgumentParser(description='Manage Log Shipping.')

# create the top-level parser
parser = argparse.ArgumentParser(prog='logship.py')
parser.add_argument('--sql-server-hostname', dest='hostname', type=str, default=os.environ.get('SQL_SERVER_HOSTNAME'), help='Server Fully Qualified Domain Name or IP Address')
parser.add_argument('--sql-server-login', dest='login', type=str, default=os.environ.get('SQL_SERVER_LOGIN'), help='SQL Login Username')
parser.add_argument('--sql-server-password', dest='password', type=str, default=os.environ.get('SQL_SERVER_PASSWORD'), help='SQL Login Password')
parser.add_argument('--dry-run', dest='is_dry_run', default=False, action='store_true', help='disables execution with sqlcmd')
subparsers = parser.add_subparsers(help='sub-command help')

# create the parser for the "init" command
parser_create_database = subparsers.add_parser('create-database', help='create-database --help')
parser_create_database.add_argument('database_name', type=str, help='database to create')
parser_create_database.set_defaults(func=createDatabase)

# create the parser for the "b" command
# parser_b = subparsers.add_parser('b', help='b help')
# parser_b.add_argument('--baz', choices='XYZ', help='baz help')

args = parser.parse_args()
args.func(args)
