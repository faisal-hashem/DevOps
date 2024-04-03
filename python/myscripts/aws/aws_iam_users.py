#Scan for all users in IAM with name, Last Activity, Active Key age, Access Key last used and creation time
from os import access
import boto3

def list_iam_users():
    iam = boto3.client('iam')
    iam_users = iam.list_users()['Users']
    list_of_users = {"Users": []}
    for user in iam_users:
        user_dict = {}
        username = user['UserName']
        created_date = user['CreateDate']
        user_dict.update({"UserName" : username})
        user_dict.update({"CreatedDate" : created_date})
        list_of_users["Users"].append(user_dict)
    return list_of_users

def list_access_keys(username):
    iam = boto3.client('iam')
    keys = iam.list_access_keys(UserName=username)['AccessKeyMetadata']
    key_dict = {}
    for key in keys: 
        username = key['UserName']
        access_key = key['AccessKeyId']
        status = key['Status']
        key_dict.update({ "Username" : username })
        key_dict.update({ "AccessKey" : access_key })
        key_dict.update({ "Status" : status })
        key_dict.values()
    return key_dict    

def main():
    iam_users = list_iam_users()
    for user in iam_users["Users"]:
        username = user['UserName']
        keys = list_access_keys(username)
        print(keys)
        
    
if __name__ == '__main__':
    main()