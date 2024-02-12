import random
from data import data
from art_logo import logo, vs
import os
os.system('cls' if os.name == 'nt' else 'clear')

def get_random_data():
    random_data = random.choice(data)
    name = random_data["name"]
    description = random_data["description"]
    country = random_data["country"]
    followers = random_data["follower_count"]
    return name, description, country, followers

def compare(choice, compare_a_followers, compare_b_followers):
    if choice == 'A':
        if compare_a_followers > compare_b_followers:
            return 1
        else:
            return 0
    elif choice == 'B':
        if compare_b_followers > compare_a_followers:
            return 1
        else:
            return 0

game_is_on = True
score = 0
answer = 0
round = 0
b_data = get_random_data()

while game_is_on:
    os.system('clear')
    print(logo)
    
    if answer == 1:
        score += 1
        print(f"You're right! Your score: {score}") 
    elif answer == 0 and round > 0:
        print(f"Sorry, that's wrong. Final score: {score}")
        break
 
    a_data = b_data
    b_data = get_random_data()
    
    print(f"Compare A: {a_data[0]} , a {a_data[1]}, from {a_data[2]}.")
    print(f"{a_data[3]} and {b_data[3]}")
    print(vs)
    print(f"Against B: {b_data[0]} , a {b_data[1]}, from {b_data[2]}.")
    choice = input("Who has more followers? Type 'A' or 'B': ")
    answer = compare(choice, a_data[3], b_data[3])
    round += 1