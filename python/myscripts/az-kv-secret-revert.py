def revert_to_placeholders():
    config_file_path = "/opt/tomcat/.xdm/config.properties"

    # Placeholder values
    placeholder1 = "DB_ADMIN_PASSWORD"
    placeholder2 = "DB_READONLY_PASSWORD"

    with open(config_file_path, 'r') as file:
        filedata = file.read()

    # Fetch actual passwords from Key Vault for identifying and replacing them
    from azure.identity import ManagedIdentityCredential
    from azure.keyvault.secrets import SecretClient

    def get_secret_from_key_vault(secret_name):
        key_vault_url = "https://kv-xdm-vm-dev-uc1.vault.azure.net/"
        credential = ManagedIdentityCredential()
        secret_client = SecretClient(
            vault_url=key_vault_url, credential=credential)
        retrieved_secret = secret_client.get_secret(secret_name)
        return retrieved_secret.value

    current_password1 = get_secret_from_key_vault("xdm-db-adm-password")
    current_password2 = get_secret_from_key_vault("xdm-db-adm-ro-password")

    # Replace the current passwords back to their placeholder values
    filedata = filedata.replace(current_password1, placeholder1)
    filedata = filedata.replace(current_password2, placeholder2)

    with open(config_file_path, 'w') as file:
        file.write(filedata)


if __name__ == "__main__":
    revert_to_placeholders()
