# Scan for all exisitng security groups 
# in all regions with name, description, 
# last modified date, inbound rules.

import boto3
import botocore
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

def report_not_used_security_groups(region='us-east-2'):
    my_config = Config(region_name=region)
    ec2 = boto3.client("ec2", config=my_config)
    rds = boto3.client("rds", config=my_config)
    elb = boto3.client("elb", config=my_config)
    elbv2 = boto3.client("elbv2", config=my_config)
    elastic_cache = boto3.client("elasticache", config=my_config)
    redshift = boto3.client("redshift", config=my_config)
    
    existing_security_groups = list_all_security_groups(region)
    ec2_instances = ec2.describe_instances()['Reservations']
    rds_instances = rds.describe_db_instances()["DBInstances"]
    elb_instances = elb.describe_load_balancers()["LoadBalancerDescriptions"]
    elbv2_instances = elbv2.describe_load_balancers()["LoadBalancers"]
    elasticcache_clusters = elastic_cache.describe_cache_clusters()["CacheClusters"]
    redshift_clusters = redshift.describe_clusters()["Clusters"]
    
    instances_sg = []
    security_groups = []
    
    if ec2_instances != []:
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
            
    if elasticcache_clusters != []: 
        elastic_cache_sg = elasticcache_clusters[0]["CacheSecurityGroups"]
        for sg in elastic_cache_sg:
            elastic_cache_sg_id = sg
            instances_sg.append(elastic_cache_sg_id) 
            
    if redshift_clusters != []: 
        redshift_sg = redshift_clusters[0]["ClusterSecurityGroups"]
        for sg in redshift_sg:
            redshift_sg_id = sg
            instances_sg.append(redshift_sg_id) 
    
    for sg_id in existing_security_groups.values():
        security_groups.append(sg_id)
     
    for i in instances_sg:
        if i in security_groups:
            security_groups.remove(i)
    
    unused_sg_count = len(security_groups)
    used_sg_count = len(instances_sg)
    total_sg_count = unused_sg_count + used_sg_count
    
    return security_groups, total_sg_count, unused_sg_count, used_sg_count, instances_sg


def delete_unused_security_groups(region='us-east-2'):
    unused_security_groups = report_not_used_security_groups(region)[0]
    my_config = Config(region_name=region)
    ec2 = boto3.client('ec2', config=my_config)
    for sg in unused_security_groups:
        network = ec2.describe_network_interfaces(Filters=[{'Name': 'group-id', 'Values': [sg]}])["NetworkInterfaces"]
        if network != []:
            ec2_dependent = network[0]["Attachment"]["InstnaceId"]
            print(f"Cannot delete {sg}. Has dependency to Instance: {ec2_dependent}")
        else:
            try:
                ec2.delete_security_group(GroupId=sg)
            except botocore.exceptions.ClientError as e:
                print(f"Could not delete security group {sg}: {e}")
                
delete_unused_security_groups(region='us-east-1')

# my_config = Config(region_name='us-east-1')
# ec2 = boto3.client('ec2', config=my_config)
# try:
#     response = ec2.delete_security_group(GroupId='sg-0989599b843190361')
#     print(response)
# except botocore.exceptions.ClientError as e:
#     print("Not allowed")
    

# sg_report = report_not_used_security_groups('us-east-2')

# print(f"Total Security Groups: {sg_report[1]}")
# print(f"Used Security Groups: {sg_report[3]}")
# print(f"Un-Used Security Groups: {sg_report[2]} \n")
# print(f"Security Groups (Not Used) ({sg_report[2]}) - {sg_report[0]}\n")
# print(f"Security Groups (Used) ({sg_report[3]}) - {sg_report[4]}\n")



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