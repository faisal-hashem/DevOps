#Develop scripts that automatically create backups 
#of important data across various AWS services (like RDS, S3, etc.) 
#and manage lifecycle policies.

from venv import create
import boto3
client = boto3.client('backup')

#Create a backup vault
def create_backup_vault(vault_name):
    vault = client.create_backup_vault(BackupVaultName=vault_name)
    print(vault)
    
def delete_backup_vault(vault_name):
    vault = client.delete_backup_vault(BackupVaultName=vault_name)
    print(vault)

def retrieve_backup_vault(vault_name):
    vault = client.describe_backup_vault(BackupVaultName=vault_name)
    vault_arn = vault['BackupVaultArn']
    return vault_arn

#Create a backup plan that point to the vault
def create_backup_plan(backup_plan_name, rule_name, vault_name):
    vault_arn = retrieve_backup_vault(vault_name)
    plan = client.create_backup_plan(BackupPlan={
        'BackupPlanName': backup_plan_name,
        'Rules': [
            {
                'RuleName': rule_name,
                'TargetBackupVaultName': vault_name,
                'ScheduleExpression': 'cron(0 19 * * ? *)',
                'StartWindowMinutes': 60,
                'CompletionWindowMinutes': 180,
                'Lifecycle': {
                    'DeleteAfterDays': 30,
                },
                'CopyActions': [
                    {
                        'DestinationBackupVaultArn': vault_arn
                    },
                ],
                'EnableContinuousBackup': False,
                'ScheduleExpressionTimezone': 'EST'
            },
        ],
    })
    print(plan)
    plan_id = plan['BackupPlanId']
    plan_arn = plan['BackupPlanArn']
    return plan_id, plan_arn

#S3 buckets reguire versioning to be enabled, need to enable

#Assign resources to the backup plan (focus on RDS, S3 and EC2)

plan = create_backup_plan('P4_plan', 'daily_backups_at_7pm', 'test_vault')
print(plan)