# Scan for all exisitng security groups 
# in all regions with name, description, 
# last modified date, inbound rules.

import boto3
from botocore.config import Config

def list_all_security_groups(region='us-east-2'):
    my_config = Config(region_name = region)
    ec2 = boto3.client("ec2", config=my_config)
    security_groups = ec2.describe_security_groups()['SecurityGroups'] 
    security_dict = {}
    for security_group in security_groups:
        group_name = security_group['GroupName']
        sg_id = security_group['GroupId']
        security_dict[group_name] = sg_id
    return security_dict

print(list_all_security_groups())
# ec2 = boto3.resource('ec2')
# ec2_client = boto3.client('ec2')

# sg = ec2.security_groups.all()
# response = ec2_client.describe_regions()
# regions = [region['RegionName'] for region in response['Regions']]
# all_groups = []

# for region in regions:
#     for group in sg:
#         all_groups.append(group.group_name)

# print(all_groups)