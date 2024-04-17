import requests

# Endpoint URL
url = "https://randomuser.me/api/"

# Send GET request
params = {'results': '5'}
response = requests.get(url, params=params)

# Check if the request was successful
if response.status_code == 200:
    # Extract data from response
    data = response.json()['results']
    for d in data:
        fname = d['name']['first']
        lname = d['name']['last']
        country = d['location']['country']
        print(f"First Name: {fname} - Last Name: {lname} - Country: {country}\n")
else:
    print("Failed to retrieve data:", response.status_code)
