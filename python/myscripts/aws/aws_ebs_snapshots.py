#Script to take snapshots of EBS volumes for backup purposes. 
#The script could also manage the snapshots by deleting old ones after a certain number of days. 

import boto3
from datetime import datetime, timedelta
from dateutil import tz

ec2 = boto3.client("ec2")

def capture_snapshot():
    volumes = ec2.describe_volumes()["Volumes"]
    for volume in volumes:
        volumeid = volume['Attachments'][0]["VolumeId"] 
        response = ec2.create_snapshot(VolumeId=volumeid)
        print(f"{response}\n")

def delete_snapshot():
    snapshots = ec2.describe_snapshots(OwnerIds=['self'])["Snapshots"]
    for snapshot in snapshots:
        snapshotid = snapshot["SnapshotId"]
        snapshot_date = snapshot["StartTime"]
        todays_date = datetime.now(tz=tz.tzutc())
        past_date = todays_date - timedelta(seconds=2)
        if snapshot_date < past_date:
            print(f"Snapshot { snapshotid } will be deleted\n")
            response = ec2.delete_snapshot(SnapshotId=snapshotid)
            print(f"{response}\n")
        else:
            print(f"Snapshot { snapshotid } has not expired and is still available")
            print(f"Snapshot Date: {snapshot_date}\n")

def main():
    snapshot_input = input("Do you want to capture snapshots of all volumes? (y/n)")
    if snapshot_input == "y":  
        capture_snapshot()
    else:
        print("No snapshots have been captured")
        
    delete_input = input("Do you want to trigger snapshot deletion check? (y/n)")
    if delete_input == "y":   
        delete_snapshot()
    else:
        print("No snapshots have been deleted")
    
if __name__ == "__main__":
    main()