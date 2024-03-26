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

# Function to scan all EC2 instances attached security groups against list of exisitng security groups
#If the security groups does not match, delete the security group

def report_not_used_security_groups(region):
    my_config = Config(region_name=region)
    ec2 = boto3.client("ec2", config=my_config)
    rds = boto3.client("rds", config=my_config)
    elb = boto3.client("elb", config=my_config)
    elbv2 = boto3.client("elbv2", config=my_config)
    
    existing_security_groups = list_all_security_groups(region)
    ec2_instances = ec2.describe_instances()['Reservations']
    rds_instances = rds.describe_db_instances()["DBInstances"]
    elb_instances = elb.describe_load_balancers()["LoadBalancerDescriptions"]
    elbv2_instances = elbv2.describe_load_balancers()["LoadBalancers"]
    
    instances_sg = []
    security_groups = []
    
    if ec2_instances[0]["Instances"][0]["SecurityGroups"] != []:
        for instance in ec2_instances:
            ec2_sg_id = instance["Instances"][0]["SecurityGroups"][0]["GroupId"]
            instances_sg.append(ec2_sg_id)
    
    if rds_instances != []: 
        rds_sg = rds_instances[0]["DBSecurityGroups"][0]["DBSecurityGroupName"]
        for sg in rds_sg:
            rds_sg_id = sg
            instances_sg.append(rds_sg_id)
    
    if elb_instances != []:    
        elb_sg = elb_instances[0]["SecurityGroups"]
        for sg in elb_sg:
            elb_sg_id = sg
            instances_sg.append(elb_sg_id)
            
    if elbv2_instances != []: 
        elbv2_sg = elbv2_instances[0]["SecurityGroups"]
        for sg in elbv2_sg:
            elbv2_sg_id = sg
            instances_sg.append(elbv2_sg_id) 
    
    for sg_id in existing_security_groups.values():
        security_groups.append(sg_id)
     
    for i in instances_sg:
        if i in security_groups:
            security_groups.remove(i)
    
    unused_sg_count = len(security_groups)
    used_sg_count = len(instances_sg)
    total_sg_count = unused_sg_count + used_sg_count
    
    print(f"Total Security Groups: {total_sg_count}")
    print(f"Used Security Groups: {used_sg_count}")
    print(f"Un-Used Security Groups: {unused_sg_count} \n")
    print(f"Security Groups (Not Used) ({ unused_sg_count }) - { security_groups }\n")
    print(f"Security Groups (Used) ({ used_sg_count }) - { instances_sg }\n")
    
    return security_groups
        
report_not_used_security_groups('us-east-2')




#print(list_all_security_groups())
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