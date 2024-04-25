from statistics import mean
import requests

def fetch_data(url, params):
    try:
        response = requests.get(url, params)
        response.raise_for_status()
        return response.json()['results']
    except requests.exceptions.RequestException as e:
        print("HTTP Request Failed:", e)
        return []

def retrieve_data(data):
        age_data = []
        for d in data:
            fname = d['name']['first']
            lname = d['name']['last']
            country = d['location']['country']
            age = d['dob']['age']
            age_data.append(age)
            print(f"First Name: {fname} - Last Name: {lname} - Country: {country} -  Age: {age}\n")
        
        max_age = max(age_data)
        min_age = min(age_data)
        avg_age = round(mean(age_data))
        
        print(f"Minimum age: {min_age} - Max age: {max_age} - Average age: {avg_age}")
        return age_data
    
def main():
    url = "https://randomuser.me/api/"
    params = {'results': '10'}
    data = fetch_data(url, params)
    age_data = retrieve_data(data)
    
if __name__ == "__main__": 
    main()

# # Endpoint URL
# url = "https://randomuser.me/api/"

# try:
#     # Send GET request
#     params = {'results': '10'}
#     response = requests.get(url, params=params)

#     #Check if the request was successful
#     if response.status_code == 200:
#         # Extract data from response
#         data = response.json()['results']
#         age_data = []
#         for d in data:
#             fname = d['name']['first']
#             lname = d['name']['last']
#             country = d['location']['country']
#             age = d['dob']['age']
#             age_data.append(age)
#             print(f"First Name: {fname} - Last Name: {lname} - Country: {country} -  Age: {age}\n")
        
#         max_age = max(age_data)
#         min_age = min(age_data)
#         avg_age = round(mean(age_data))
        
#         print(f"Minimum age: {min_age} - Max age: {max_age} - Average age: {avg_age}")
        
#     else:
#         print("Failed to retrieve data:", response.status_code)
        
# except requests.exceptions.RequestException as e:
#     print("HTTP Request Failed:", e)
    
