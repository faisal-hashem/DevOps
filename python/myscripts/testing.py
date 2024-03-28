import boto3
from botocore.config import Config

# Initialize a boto3 client
my_config = Config(region_name = 'us-east-1')
eb_client = boto3.client('elasticbeanstalk', config=my_config)

# Specify your Elastic Beanstalk environment name
environment_name = 'Vpro-app-11-9-env'

# Retrieve the environment description
response = eb_client.describe_environment_resources(EnvironmentName=environment_name)

# Navigate through the response to find the security groups
instances = response['EnvironmentResources']['Instances']
for instance in instances:
    print(f"Instance ID: {instance['Id']}")
    for security_group in instance['SecurityGroups']:
        print(f"Security Group ID: {security_group}")
