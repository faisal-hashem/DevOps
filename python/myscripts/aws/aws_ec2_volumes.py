#Scan for EC2 Volumes, volume state, size, created date and attached resources

from math import e
import boto3
from botocore.config import Config
from datetime import datetime, timedelta
from dateutil import tz

def get_ec2_volume(region):
    config = Config(region_name=region)
    ec2 = boto3.client('ec2', config=config)
    volume = ec2.describe_volumes()['Volumes']
    all_volumes = {}
    for v in volume:
        volume_id = v['Attachments'][0]['VolumeId']
        size = v['Size']
        state = v['Attachments'][0]['State']
        date_created = v['CreateTime']
        #date_created = date_created.strftime('%m-%d-%Y %H:%M:%S %Z')
        instance_id = v['Attachments'][0]['InstanceId']
        all_volumes[volume_id] = [instance_id, size, state, date_created]
    return all_volumes
        
#Snapshot of EBS volumes for backup purposes 
def create_snapshot(volume_id, region):
    config = Config(region_name=region)
    ec2 = boto3.client('ec2', config=config)
    snapshot = ec2.create_snapshot(VolumeId=volume_id)
    snapshotid = snapshot['SnapshotId']
    print(f"Snapshot for {volume_id} has been created. Snapshot ID: {snapshotid}")

#Delete after 1 day
def delete_snapshot(region):
    config = Config(region_name=region)
    get_ec2 = boto3.client('ec2', config=config)
    get_snapshots = get_ec2.describe_snapshots(OwnerIds=['self'])
    snap_ids = get_snapshots['Snapshots']
    for snap in snap_ids:
        snap_id = snap['SnapshotId']
        snap_id_date = snap['StartTime']
        today = datetime.now(tz=tz.tzutc())
        expiration_date = timedelta(days=1)
        expire = today - expiration_date
        if snap_id_date < expire:
            get_ec2.delete_snapshot(SnapshotId=snap_id)
            print(f"{snap_id} has been deleted")
        else:
            print("There are no snapshots to delete")


def main():
    ec2 = boto3.client('account')
    regions = ec2.list_regions(MaxResults=50, RegionOptStatusContains=['ENABLED_BY_DEFAULT'])['Regions']
    for region in regions:
        region_name = region['RegionName']
        ec2_volume = get_ec2_volume(region_name)
        print(region_name)
        for vol in ec2_volume:
            vol_values = ec2_volume[vol]
            vol_id = vol
            instance_id = vol_values[0]
            vol_size = vol_values[1]
            vol_state = vol_values[2]
            vol_date = vol_values[3]
            print(f"Volume ID: {vol_id} - Instance ID: {instance_id} - State: {vol_state} - Size: {vol_size} - Date: {vol_date}")
            #create_snapshot(vol_id, region_name)
            
        
if __name__ == "__main__":
    main()