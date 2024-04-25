import requests
import random

def retrieve_data(url):
    try:
        response = requests.get(url)
        response.raise_for_status()
        data = response.json()["data"]
        return data
    except requests.exceptions.HTTPError as e:
        print("HTTP Failed Error: ", e)

def draw_cards(data):
    cards = 0
    hand = []
    while cards < 5:
        hand.append(random.choice(data))
        cards += 1
    return hand

def display_card(hand):
    for card in hand:
        if "Monster" in card["type"]:
            print(f"{card["name"]} - Type: {card['type']} - Attack: {card["atk"]} - Defense: {card['def']} - Level: {card['level']} - Race: {card['race']}\n")
        if card["type"] == "Trap Card" or card["type"] == "Spell Card":
            print(f"{card["name"]} - Type: {card['type']} - Description: {card['desc']}\n")   

def main():
    print("Welcome to YuGiOh!\n")
    print("Lets draw some cards!\n")
    print("Here is your hand.\n")
    url = "https://db.ygoprodeck.com/api/v7/cardinfo.php"
    data = retrieve_data(url)
    trap = display_card(data)
    # your_hand = draw_cards(data)
    # display_card(your_hand)
    # computer_hand = draw_cards(data)
    
    
if __name__ == "__main__":
    main()