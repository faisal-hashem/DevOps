import requests

# Replace these variables with your information
azure_devops_organization = "GA-Infra"
azure_devops_project = "Terraform"
personal_access_token = "kgwmf22ocwpovj2zmjq5xadtomrjuk7qgojnetlawlr4nsaqd2sa"
base_url = f"https://dev.azure.com/{
    azure_devops_organization}/{azure_devops_project}/_apis/"

# Basic Authentication Header
auth_headers = {
    'Authorization': f'Basic {personal_access_token}'
}


def list_repos():
    url = f"{base_url}git/repositories?api-version=6.0"
    response = requests.get(url, headers=auth_headers)
    repos = response.json()['value']
    return [(repo['name'], repo['id']) for repo in repos]


list_repos()

# def main():
#     for repo_name, repo_id in list_repos():
#         print(f"Repository: {repo_name}")


# if __name__ == "__main__":
#     main()
