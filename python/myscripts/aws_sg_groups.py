# Scan for all exisitng security groups 
# in all regions with name, description, 
# last modified date, inbound rules.

import boto3

ec2 = boto3.resource('ec2')
ec2_client = boto3.client('ec2')

sg = ec2.security_groups.all()
response = ec2_client.describe_regions()
regions = [region['RegionName'] for region in response['Regions']]

for region in regions:
    print(region)

all_groups = []

for group in sg:
    all_groups.append(group.group_name)

print(all_groups)