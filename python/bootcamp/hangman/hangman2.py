import random
import os
import platform
from hangman_art import logo, stages
from hangman_words import word_list

def clear_terminal():
    # Check if the operating system is Windows
    if platform.system() == "Windows":
        os.system('cls')  # Clear terminal for Windows
    else:
        os.system('clear')  # Clear terminal for Unix/Linux/MacOS

print(logo)
chosen_word = random.choice(word_list)
len_chosen_word = len(chosen_word)

display = []
for letter in range(len_chosen_word):
    display += "_"
print(display)
    
end_of_game = False
lives = 6

while end_of_game == False:
    guess = input("Enter a guess:")
    if guess in display:
        print(f"The letter {guess} has already been guessed\n")  
    
    for position in range(len_chosen_word):
        if guess == chosen_word[position]:
            display[position] = guess
      
    if guess not in chosen_word:
        lives -= 1
        print(f"{guess} is not in the word list.\n")
        if lives == 0:
            print("You Lost!\n")
            print(f"The word was {chosen_word}")
            end_of_game = True        

    if "_" not in display:
        print("You Won!\n")
        end_of_game = True

    print(display)    
    print(stages[lives])