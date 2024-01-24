import paramiko
import os

my_machines = [
    "10.x.x.x",
    "10.x.x.x",
]

ssh_key = "ENTER SSH KEY TO COPY OVER"
user = "ENTER ADMIN USER TO SSH INTO SERVER"
password = "ENTER ADMIN PASSWORD TO SSH INTO SERVER"
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
