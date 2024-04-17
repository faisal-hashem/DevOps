import boto3
from botocore.config import Config

#Assumes you have aws configure set up in terminal

#Lists all regions in AWS regions
def available_regions():
    client = boto3.client('ec2')
    regions = [region['RegionName'] for region in client.describe_regions()['Regions']]
    return regions

#Uses list of Regions to create a Dictionary of all EC2 Instances in ALL regions
def global_ec2_instances():
    regions = available_regions()
    ec2_instances = {}
    for region in regions:
        my_config = Config(region_name = region)
        ec2 = boto3.client("ec2", config=my_config)
        instances = ec2.describe_instances()
        for i in instances['Reservations']:
            instance_name = i['Instances'][0]['Tags'][0]['Value']
            instance_state = i['Instances'][0]['State']['Name']
            instance_region = region
            instance_id = i['Instances'][0]['InstanceId']
            ec2_instances[instance_name] = [instance_id, instance_state, instance_region]
    return ec2_instances

#STOPS all EC2 instances in all regions
def stop_all_ec2_instances():
    ec2 = global_ec2_instances()
    instances = ec2.values()
    regions = available_regions()
    for region in regions:
        my_config = Config(region_name = region)
        ec2 = boto3.client("ec2", config=my_config)
        for instance in instances:
            if region == instance[2]:
                response = ec2.stop_instances(InstanceIds=[instance[0]])
                print(response)

#DELETES all EC2 instances in all regions            
def terminate_all_ec2_instances():
    ec2 = global_ec2_instances()
    instances = ec2.values()
    regions = available_regions()
    for region in regions:
        my_config = Config(region_name = region)
        ec2 = boto3.client("ec2", config=my_config)
        for instance in instances:
            if region == instance[2]:
                response = ec2.terminate_instances(InstanceIds=[instance[0]])
                print(response)

#Lists all EC2 instances in default region
def ec2_instances_report():
    ec2 = boto3.resource('ec2')
    instances = ec2.instances.all()
    for instance in instances:
        instance_state = instance.state['Name']
        instance_name = instance.tags[0]['Value']
        print(f"EC2 Name: {instance_name} - EC2 State: {instance_state}")

#Stops all EC2 instances in default region        
def stop_ec2_instances():
    ec2 = boto3.resource('ec2')
    instances = ec2.instances.all()
    for instance in instances:
        instance_state = instance.state['Name']
        instance_name = instance.tags[0]['Value']
        if instance_state == 'running' or instance_state == 'pending':
            print(f"{instance_name} is currently running")
            instance.stop(Force=True)
            print(f"{instance_name} has been stopped")
     
#Stop all EC2 Instances in passed in region. 
def stop_regional_ec2_instances(region='us-east-2'):
    #Configure region
    my_config = Config(region_name = region)
    ec2 = boto3.client("ec2", config=my_config)
    #Grab instances from set region
    instances = ec2.describe_instances()
    for instance in instances["Reservations"]:
        instance_id = instance["Instances"][0]["InstanceId"]
        #Terminate instance
        response = ec2.stop_instances(InstanceIds=[instance_id])
        print(response)     
                                
#Delete all EC2 Instances in passed in region. 
def delete_regional_ec2_instances(region='us-east-2'):
    #Configure region
    my_config = Config(region_name = region)
    ec2 = boto3.client("ec2", config=my_config)
    #Grab instances from set region
    instances = ec2.describe_instances()
    for instance in instances["Reservations"]:
        instance_id = instance["Instances"][0]["InstanceId"]
        #Terminate instance
        response = ec2.terminate_instances(InstanceIds=[instance_id])
        print(response)