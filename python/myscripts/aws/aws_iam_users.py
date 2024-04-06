#Scan for all users in IAM with name, Last Activity, Active Key age, Access Key last used and creation time
from os import access
import boto3
from datetime import datetime

iam = boto3.client('iam')

def list_iam_users():
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

def access_key_last_used(accesskey):
    key = iam.get_access_key_last_used(AccessKeyId=accesskey)
    date = key['AccessKeyLastUsed']['LastUsedDate']
    date = date.strftime('%m-%d-%Y %H:%M:%S %Z')
    return date

def list_access_keys(username):
    keys = iam.list_access_keys(UserName=username)['AccessKeyMetadata']
    key_dict = {}
    for key in keys: 
        username = key['UserName']
        access_key = key['AccessKeyId']
        status = key['Status']
        last_used_date = access_key_last_used(access_key)
        key_dict.update({ "Username" : username })
        key_dict.update({ "AccessKey" : access_key })
        key_dict.update({ "Status" : status })
        key_dict.update({ "Last Used" : last_used_date})
        key_dict.values()
    return key_dict 


def main():
    iam_users = list_iam_users()
    allkeys = []
    for user in iam_users["Users"]:
        username = user['UserName']
        allkeys.append(list_access_keys(username))
    print(allkeys)
        
if __name__ == '__main__':
    main()