############### Blackjack Project #####################

# Difficulty Normal 😎: Use all Hints below to complete the project.
# Difficulty Hard 🤔: Use only Hints 1, 2, 3 to complete the project.
# Difficulty Extra Hard 😭: Only use Hints 1 & 2 to complete the project.
# Difficulty Expert 🤯: Only use Hint 1 to complete the project.

############### Our Blackjack House Rules #####################

# The deck is unlimited in size.
# There are no jokers.
# The Jack/Queen/King all count as 10.
# The the Ace can count as 11 or 1.
# Use the following list as the deck of cards:
# cards = [11, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10]
# The cards in the list have equal probability of being drawn.
# Cards are not removed from the deck as they are drawn.
# The computer is the dealer.

from art import logo
import random

# def blackjack():
#   play_decision = input("Do you want to play a game of Blackjack? Type 'y' or 'n'")
#   while play_decision == 'y':

print(logo)
cards = [11, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10]

your_card1 = random.choice(cards)
your_card2 = random.choice(cards)
your_draw_card = random.choice(cards)

com_card1 = random.choice(cards)
com_card2 = random.choice(cards)
com_draw_card = random.choice(cards)

print(f"Your cards: [{your_card1}, {your_card2}]")
print(f"Computer's first card: {com_card1}")
draw_again_ans = input("Type 'y' to get another card, type 'n' to pass: ")


def winner():
    your_total = your_card1 + your_card2
    com_total = com_card1 + com_card2
    if your_total < 16:
        print("The total is below 16, you need to draw again.")

    elif your_total > com_total:
        "You Win"
    else:
        "You Lost"


if draw_again_ans == 'n':
    print(f"Your final hand: [{your_card1}, {your_card2}]")
    print(f"Computer's final hand: [{com_card1}, {com_card2}]")
