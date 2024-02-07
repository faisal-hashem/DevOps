import paramiko
import getpass


class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKCYAN = '\033[96m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'


my_machines = [
    "ENTER_IP_HERE",
]

services = [
    "SplunkForwarder",
    "qualys-cloud-agent",
    "rubrik",
]


def ssh_command(hostname, username, password, command):
    try:
        client = paramiko.SSHClient()
        client.set_missing_host_key_policy(paramiko.AutoAddPolicy())

        client.connect(hostname, port=22, username=username, password=password)

        stdin, stdout, stderr = client.exec_command(command)
        output = stdout.read()

        # Close the connection
        client.close()

        return output.decode('utf-8')
    except Exception as e:
        print(f"An error occurred: {e}")
        return None


username = input("Enter ADMIN Username: ")
password = getpass.getpass("Enter ADMIN Password: ")
for machine in my_machines:
    output = []
    for service in services:
        command = f'sudo systemctl status {service} | head -n 3'
        output = ssh_command(machine, username, password, command)
        print(machine)
        print(f"{bcolors.OKGREEN}{output}{bcolors.ENDC}")
