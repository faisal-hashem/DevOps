import boto3

def get_unused_volumes():
    ec2 = boto3.resource('ec2')

    unused_volumes = []
    for volume in ec2.volumes.all():
        print(volume)
        
get_unused_volumes()