#https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/ec2/instance/index.html

import boto3

ec2 = boto3.resource('ec2')

for instance in ec2.instances.all():
     print(
         "Name: {0}\n'Platform: {1}\n Type: {2}\nID: {3}\nAMI: {4}\nState: {5}\n".format(
          instance.tags[0]['Value'], instance.platform, instance.instance_type, instance.id, instance.image.id, instance.state
         )
     )