#!/usr/bin/env python3
import argparse
from jinja2 import Environment, FileSystemLoader
import os
import subprocess
import sys

sqlcmd = r'/opt/mssql-tools/bin/sqlcmd'

def getTemplate(args, template_name):
  file_loader = FileSystemLoader(args.template_directory)
  env = Environment(loader=file_loader)
  return env.get_template(template_name)

def getDatabaseCategory(args):
  if args.database_name.lower() in ['master','msdb','model','tempdb','resource','distribution','system_databases']:
    return 'SYSTEM_DATABASES'
  return 'USER_DATABASES'

def getBackupDirectoryStructure(args):
  category = getDatabaseCategory(args)
  return f'{{ServerName}}${{InstanceName}}{{DirectorySeparator}}{category}{{DirectorySeparator}}{{DatabaseName}}{{DirectorySeparator}}{{BackupType}}_{{Partial}}_{{CopyOnly}}'

def runSqlCommand(args, query):
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

def backupDatabase(args):
  template = getTemplate(args, 'backup_database.sql.j2')
  query = template.render(databases=args.database_name,
                          directory=args.directory,
                          directory_structure=getBackupDirectoryStructure(args),
                          backup_type=args.backup_type.upper(),
                          cleanup_time=args.cleanup_time,
                          compress=args.compress,
                          init=args.init,
                          verify=args.verify)
  runSqlCommand(args, query)

def createDatabase(args):
  template = getTemplate(args, 'create_database.sql.j2')
  query = template.render(database_name=args.database_name)
  runSqlCommand(args, query)

def initServer(args):
  query = ''
  with open(f'{args.template_directory}/MaintenanceSolution.sql', 'r') as file:
    query = file.read()
  runSqlCommand(args, query)

parser = argparse.ArgumentParser(description='Manage Log Shipping.')

# create the top-level parser
parser = argparse.ArgumentParser(prog='logship.py')
parser.add_argument('--sql-server-hostname', dest='hostname', type=str, default=os.environ.get('SQL_SERVER_HOSTNAME'), help='Server Fully Qualified Domain Name or IP Address')
parser.add_argument('--sql-server-login', dest='login', type=str, default=os.environ.get('SQL_SERVER_LOGIN'), help='SQL Login Username')
parser.add_argument('--sql-server-password', dest='password', type=str, default=os.environ.get('SQL_SERVER_PASSWORD'), help='SQL Login Password')
parser.add_argument('--dry-run', dest='is_dry_run', default=False, action='store_true', help='disables execution with sqlcmd')
parser.add_argument('--template-directory', dest='template_directory', default='/scripts/templates', type=str, help='directory to search for jinja2 templates.  default: /scripts/templates')
subparsers = parser.add_subparsers(help='sub-command help')

# create the parser for the "init-server" command
parser_init_server =  subparsers.add_parser('init-server', help='init-server --help')
parser.set_defaults(func=initServer)

# create the parser for the "create-database" command
parser_create_database = subparsers.add_parser('create-database', help='create-database --help')
parser_create_database.add_argument('database_name', type=str, help='database to create')
parser_create_database.set_defaults(func=createDatabase)

parser_backup_database = subparsers.add_parser('backup-database', help='backup-database --help')
parser_backup_database.add_argument('backup_type', type=str, choices=['full', 'diff', 'log'], help='backup type.')
parser_backup_database.add_argument('database_name', type=str, help='database to backup.')
parser_backup_database.add_argument('--directory', metavar='PATH', dest='directory', type=str, help='root backup directory.  default: /var/opt/mssql/logship', default='/var/opt/mssql/logship')
parser_backup_database.add_argument('--cleanup-time', metavar='N', dest='cleanup_time', default=0, type=int, help='number of hours to keep backups before deleting.  default: 0 (no deletion)')
parser_backup_database.add_argument('--compress', dest='compress', default=False, action='store_true', help='when provided, backup file is compressed.  default: false')
parser_backup_database.add_argument('--init', dest='init', default=False, action='store_true', help='when provided, backup file is overwritten rather than appended.  default: false')
parser_backup_database.add_argument('--verify', dest='verify', default=False, action='store_true', help='when provided, backup file is validated on the host by simulating a restore. default: false')
parser_backup_database.set_defaults(func=backupDatabase)

args = parser.parse_args()
args.func(args)
