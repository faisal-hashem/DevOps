from hangman_words import word_list
from hangman_art import stages, logo
import random                                                                                                                  

#word_list = ["aardvark", "baboon", "camel"]
chosen_word = random.choice(word_list)

# Testing code
print(f'Pssst, the solution is {chosen_word}.')
print(logo)

display = []
word_length = len(chosen_word)
for c in range(word_length):
    display += "_"

print(display)

lives = 6
end_of_game = False
while not end_of_game:
    guessed_right = 0
    guess = input("Guess a letter: ").lower()
    
    if guess in display:
      print(f"The letter {guess} has already been guessed")  
    
    for position in range(word_length):
      letter = chosen_word[position]
      if guess == letter:
        display[position] = letter
        guessed_right += 1
    
    #if guessed_right == 0:
    #  lives -= 1

    if guess not in chosen_word:
      print(f"The letter {guess} is not in the word, you lose a life")
      lives -= 1
      if lives == 0:
        end_of_game = True
        print("You lost")

    if "_" not in display:
      end_of_game = True
      print("You won!")

    print(stages[lives])
    print(display)