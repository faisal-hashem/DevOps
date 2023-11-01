# imports AZ User Managed Identity and AKV modules
from azure.identity import ManagedIdentityCredential
from azure.keyvault.secrets import SecretClient

# Initilized the User MI that is attached to the VM using the Object ManagedIdentityCredential()


def get_secret_from_key_vault(secret_name):
    key_vault_url = "https://kv-xdm-vm-dev-uc1.vault.azure.net/"
    credential = ManagedIdentityCredential()
    # set AZ SecretClient vault_url/credential parameters to the set variable.
    secret_client = SecretClient(
        vault_url=key_vault_url, credential=credential)
    retrieved_secret = secret_client.get_secret(secret_name)
    return retrieved_secret.value


def update_properties_file(secret_name1_value, secret_name2_value):
    config_file_path = "/opt/tomcat/.xdm/config.properties"
    with open(config_file_path, 'r') as file:
        filedata = file.read()

    # Replace placeholders with the actual secrets from Key Vault
    filedata = filedata.replace('DB_ADMIN_PASSWORD', secret_name1_value)
    filedata = filedata.replace('DB_READONLY_PASSWORD', secret_name2_value)

    with open(config_file_path, 'w') as file:
        file.write(filedata)


if __name__ == "__main__":
    secret_name1 = "xdm-db-adm-password"
    secret_name2 = "xdm-db-adm-ro-password"

    password1 = get_secret_from_key_vault(secret_name1)
    password2 = get_secret_from_key_vault(secret_name2)

    update_properties_file(password1, password2)
