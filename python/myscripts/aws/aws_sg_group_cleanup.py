import boto3
import botocore
from botocore.config import Config

#Return existing security groups in a dictionary in the current region with SG Name and ID
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

# Compare ec2, rds, elb, elbv2, elastic cache, redshift attached security groups against list of exisitng security groups
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
    
    #Return security groups that are not attached, number of total SG, Used SG and Not Used SG. 
    return security_groups, total_sg_count, unused_sg_count, used_sg_count, instances_sg


def delete_unused_security_groups(region='us-east-2'):
    unused_security_groups = report_not_used_security_groups(region)[0]
    my_config = Config(region_name=region)
    ec2 = boto3.client('ec2', config=my_config)
    #Double Check: Checks if any security groups are attached to a instance
    for sg in unused_security_groups:
        network = ec2.describe_network_interfaces(Filters=[{'Name': 'group-id', 'Values': [sg]}])["NetworkInterfaces"]
        if network != []:
            ec2_dependent = network[0]["Attachment"]["InstnaceId"]
            print(f"Cannot delete {sg}. Has dependency to Instance: {ec2_dependent}")
        else:
            try:
                #Deletes Security Group
                ec2.delete_security_group(GroupId=sg)
            except botocore.exceptions.ClientError as e:
                #If Error occurs during deletion such as SG dependencies or something.
                print(f"Could not delete security group {sg}: {e}")
                
print(list_all_security_groups(region='us-east-2'))