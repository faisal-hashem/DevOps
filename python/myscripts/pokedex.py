import requests

def fetch_pokemon(pokemon):
    url = f'https://courses.cs.washington.edu/courses/cse154/webservices/pokedex/pokedex.php?pokemon={pokemon}'
    response = requests.get(url)
    
    if response.status_code == 200:
        posts = response.json()
        return posts
    else:
        return "Failed to fetch posts"

def pokemon_details(pokemon):
    pokemon_name = pokemon['name']
    pokemon_hp = pokemon['hp']
    pokemon_type = pokemon['info']['type']
    pokemon_weakness = pokemon['info']['weakness']
    pokemon_moves = pokemon['moves']
    
    print(f"{pokemon_name}")
    print(f"HP: {pokemon_hp}")
    print(f"Type: {pokemon_type}")
    print(f"Weaknesses: {pokemon_weakness}")
    print("Moves: \n")
    
    for i in pokemon_moves:
        move_name = i['name']
        move_type = i['type']
        print(f"Name: {move_name}")
        print(f"Type: {move_type}")
        print("\n")

if __name__ == "__main__":
    user_input = input("Enter pokemon name: ")
    pokemon = fetch_pokemon(user_input)
    pokemon_details(pokemon)
