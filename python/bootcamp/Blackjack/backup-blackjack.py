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
import os
os.system('cls' if os.name == 'nt' else 'clear')

# print(logo)
cards = [11, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10]

def starter_cards():
    user_cards = []
    for i in range(2):
        random_card = random.choice(cards)
        user_cards.append(random_card)
    return user_cards

def deal_cards(input_card):
    for i in range(1):
        random_card = random.choice(cards)
        input_card.append(random_card)
    return input_card

# def print_cards(user_input, user_total, com_input, com_total):
#     print(f"Your cards: {user_input}, current score: {user_total}")
#     print(f"Computer's first card: {com_total}")
#     print(f"Your final hand: {user_input}, final score: {user_total}")
#     print(f"Computer's final hand: {com_input}, final score: {com_total}")

def blackjack():
    os.system('clear')
    play_blackjack = input("Do you want to play a game of BlackJack? (y/n): ")
    if play_blackjack == 'y':
        user_starter_cards = starter_cards()
        user_sum = sum(user_starter_cards)
        com_starter_cards = starter_cards()
        com_first_card = com_starter_cards[0]

        print(f"Your cards: {user_starter_cards}, current score: {user_sum}")
        print(f"Computer's first card: {com_first_card}")

        play_game = True
        while play_game:
            draw_card = input("Type 'y' to get another card, type 'n' to pass: ")
            
            if draw_card == 'y':
                user_starter_cards = deal_cards(user_starter_cards)
                if sum(user_starter_cards) > 21:
                    user_sum = sum(user_starter_cards)
                    print(f"Your cards: {user_starter_cards}, current score: {user_sum}")
                    print(f"Computer's first card: {com_first_card}")
                    print(f"Your final hand: {user_starter_cards}, final score: {user_sum}")
                    com_sum = sum(com_starter_cards)
                    print(f"Computer's final hand: {com_starter_cards}, final score: {com_sum}")
                    print("You went over. You lose")
                    
                elif sum(user_starter_cards) == 21:
                    user_sum = sum(user_starter_cards)
                    print(f"Your cards: {user_starter_cards}, current score: {user_sum}")
                    print(f"Computer's first card: {com_first_card}")
                    print(f"Your final hand: {user_starter_cards}, final score: {user_sum}")
                    print(f"Computer's final hand: {com_starter_cards}")
                    print("You Win!")
                    
                else:
                    user_sum = sum(user_starter_cards)
                    print(f"Your cards: {user_starter_cards}, current score: {user_sum}")
                    print(f"Computer's first card: {com_first_card}")
                    
            elif draw_card == 'n':
                if sum(user_starter_cards) < 21:
                    user_sum = sum(user_starter_cards)
                    print(f"Your final hand: {user_starter_cards}, your score: {user_sum}")
                    print(f"Computer's first card: {com_first_card}")
                    com_sum = sum(com_starter_cards)
                    print(f"Computer's hand: {com_starter_cards}, computer score: {com_sum}")
                    if com_sum < 21:
                        while com_sum < 21:
                            com_starter_cards = deal_cards(com_starter_cards)
                            com_sum = sum(com_starter_cards)
                            print(f"Computer's hand: {com_starter_cards}, computer score: {com_sum}")                
                                
                    if com_sum == 21:
                        print("You Lose!")
                        print(f"Your final hand: {user_starter_cards}, your final score: {user_sum}")
                        print(f"Computer's final hand: {com_starter_cards}, computers final score: {com_sum}")
                        
                    if com_sum > 21:
                        print("You Win!") 
                        print(f"Your final hand: {user_starter_cards}, your final score: {user_sum}")
                        print(f"Computer's final hand: {com_starter_cards}, computer final score: {com_sum}")            
                          
                elif sum(user_starter_cards) == 21:
                    user_sum = sum(user_starter_cards)
                    print("You Win!")
                    print(f"Your final hand: {user_starter_cards}, your final score: {user_sum}")
                    print(f"Computer's final score: {com_first_card}")
        
        # if com_sum > user_sum:
        #     print("You went over. You lose!")
        # elif user_sum > com_sum:
        #     print("You win!")
        
        blackjack()            
    else:
        print("Goodbye!")
        
blackjack()

# decision = TRUE
# while decision:
#     print(f"Your cards: [{your_card1}, {your_card2}], current score: {total}")
#     print(f"Computer's first card: {com_card1}")
#     draw_again_ans = input("Type 'y' to get another card, type 'n' to pass: ")



# def winner():
#     your_total = your_card1 + your_card2
#     com_total = com_card1 + com_card2
#     if your_total < 16:
#         print("The total is below 16, you need to draw again.")

#     elif your_total > com_total:
#         "You Win"
#     else:
#         "You Lost"


# if draw_again_ans == 'n':
#     print(f"Your final hand: [{your_card1}, {your_card2}]")
#     print(f"Computer's final hand: [{com_card1}, {com_card2}]")
