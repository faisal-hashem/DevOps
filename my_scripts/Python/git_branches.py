import requests
import hcl

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


def list_branches(repo_id):
    url = f"{base_url}git/repositories/{repo_id}/refs?api-version=6.0"
    response = requests.get(url, headers=auth_headers)
    refs = response.json()['value']
    return [ref['name'] for ref in refs if ref['name'].startswith('refs/heads/')]


def get_terraform_files(repo_id, branch_name):
    url = f"{base_url}git/repositories/{repo_id}/items?scopePath=/&versionDescriptor.version={
        branch_name}&versionDescriptor.versionType=branch&recursionLevel=Full&api-version=6.0"
    response = requests.get(url, headers=auth_headers)
    items = response.json()['value']
    return [item['path'] for item in items if item['path'].endswith('.tf')]


def get_file_content(repo_id, path, branch_name):
    url = f"{base_url}git/repositories/{repo_id}/items?path={path}&versionDescriptor.version={
        branch_name}&versionDescriptor.versionType=branch&includeContent=true&api-version=6.0"
    response = requests.get(url, headers=auth_headers)
    return response.json()['content']


def parse_terraform_source(tf_content):
    try:
        obj = hcl.loads(tf_content)
        # This is a simplification; you might need to navigate through the parsed structure
        # depending on your Terraform file structure and what you want to extract.
        return [resource['source'] for resource in obj.get('resource', {}).values()]
    except Exception as e:
        print(f"Error parsing HCL: {e}")
        return []


def main():
    for repo_name, repo_id in list_repos():
        print(f"Repository: {repo_name}")
        for branch_name in list_branches(repo_id):
            print(f"  Branch: {branch_name}")
            for tf_file in get_terraform_files(repo_id, branch_name):
                content = get_file_content(repo_id, tf_file, branch_name)
                sources = parse_terraform_source(content)
                if sources:
                    print(f"    {tf_file}: {sources}")


if __name__ == "__main__":
    main()
