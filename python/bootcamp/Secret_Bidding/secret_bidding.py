from art import logo
from statistics import mean
import os
os.system('cls' if os.name == 'nt' else 'clear')

print(logo)
print("Welcome to the secret auction program.")

auction_list = {}


def add_to_secret_auction(name, bid):
    auction_list[name] = bid


def average_secret_auction(dictionary):
    amount = 0
    people = 0
    for i in auction_list:
        auction_list[i] += amount
        people += 1

    max_value = max(auction_list.values())
    max_name = list(auction_list.keys())[list(
        auction_list.values()).index(max_value)]

    print(f"The winner is {max_name} with a bid of ${max_value}")


bidding_game = True
while bidding_game == True:
    input_name = str(input("What is your name?\n"))
    input_bid = int(input("What's your bid? $"))

    add_to_secret_auction(name=input_name, bid=input_bid)

    input_bidders = str(
        input("Are there any other bidders? Type 'yes' or 'no'.\n"))

    os.system('cls')

    if input_bidders == 'no':
        average_secret_auction(dictionary=auction_list)
        bidding_game = False
