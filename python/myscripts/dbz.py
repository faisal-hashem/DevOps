import requests

def get_characters(base_url):
    characters = []
    page = 1
    while True:
        url = f"{base_url}?page={page}&limit=20"
        try:
            response = requests.get(url)
            response.raise_for_status()
            data = response.json()["items"]
            if not data:
                break
            characters.extend(data)
            page += 1
        except requests.exceptions.RequestException as e:
            print("HTTP Failed with Error: ", e)
    return characters

def get_planets(planet_url):
    planets = []
    page = 1
    while True:
        url = f"{planet_url}?page={page}&limit=20"
        try:
            response = requests.get(url)
            response.raise_for_status()
            data = response.json()["items"]
            if not data:
                break
            planets.extend(data)
            page += 1
        except request.exceptions.RequestException as e:
            print("HTTP Failed with Error: ", e)
    return planets
            

def format_data(data):
    for item in data:
        if item['race'] == 'God' or item['race'] == 'Saiyan':
            name = item['name']
            race = item['race']
            ki = item['ki']
            maxki = item['maxKi']
            print(f"Name: {name}, Race: {race}, Maxki: {maxki}, ki: {ki}")

def main():
    base_url = "https://dragonball-api.com/api/characters"
    planet_url = "https://dragonball-api.com/api/planets"
    data = get_characters(base_url)  
    characters = format_data(data)
    planet_data = get_planets(planet_url)
    print(planet_data)

if __name__ == "__main__":
    main()