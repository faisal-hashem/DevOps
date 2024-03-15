import boto3

ec2 = boto3.resource('ec2')
sg = ec2.SecurityGroup('group_name')
for s in sg:
    print(s)