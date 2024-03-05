import paramiko
import os

my_machines = [
    "10.225.128.28",
]

ssh_key = input("ENTER SSH KEY: ")
user = input("ENTER ADMIN USER: ")
password = input("ENTER ADMIN PASSWORD: ")
ssh = paramiko.SSHClient()
ssh_directory = '~/.ssh/'

for i in my_machines:
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    ssh.connect(i, username=user, password=password)
    isExist = os.path.exists(ssh_directory)

    if isExist:
        command = f'echo {ssh_key} >> ~/.ssh/authorized_keys'
    else:
        command = f'mkdir -p ~/.ssh/ && echo {
            ssh_key} >> ~/.ssh/authorized_keys'

    ssh.exec_command(command)
    ssh.close()
