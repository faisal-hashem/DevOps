import paramiko
from configparser import ConfigParser

my_machines = [""]
config = ConfigParser()


password = ""
user = ""

for ip in my_machines:
    try:
        ssh = paramiko.SSHClient()
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        ssh.connect(ip, username=user, password=password)

        # Use 'echo' with the -e flag to interpret backslash escapes (like \n)
        command = f"mkdir /tmp/test"
        stdin, stdout, stderr = ssh.exec_command(command)

        # Check for errors
        error = stderr.read().decode().strip()
        if error:
            print(f"Error on {ip}: {error}")

        ssh.close()
    except Exception as e:
        print(f"Failed to connect or execute on {ip}: {e}")

# Close SSH connection outside the loop
ssh.close()
