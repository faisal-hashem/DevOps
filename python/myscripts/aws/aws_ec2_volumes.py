#Scan for EC2 Volumes, volume state, size, created date and attached resources

import boto3
from botocore.config import Config

def get_ec2_volume(region):
    config = Config(region_name=region)
    ec2 = boto3.client('ec2', config=config)
    volume = ec2.describe_volumes()['Volumes']
    for v in volume:
        volume_id = v['Attachments'][0]['VolumeId']
        size = v['Size']
        state = v['Attachments'][0]['State']
        date_created = v['CreateTime']
        instance_id = v['Attachments'][0]['InstanceId']
        print(f"Volume ID: {volume_id} -Instance ID: {instance_id} - State: {state} - Size: {size} - Date: {date_created}")
        
def main():
    ec2 = boto3.client('account')
    regions = ec2.list_regions(MaxResults=50, RegionOptStatusContains=['ENABLED_BY_DEFAULT'])['Regions']
    for region in regions:
        region_name = region['RegionName']
        print(region_name)
        print(get_ec2_volume(region_name))

if __name__ == "__main__":
    main()