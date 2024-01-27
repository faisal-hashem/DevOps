import random
number = random.choice(range(100))


def guess_number(guess):
    if guess > number:
        print("Too high.")
        print("Guess again.")
    elif guess < number:
        print("Too low.")
        print("Guess again.")
    elif guess == number:
        return 0


def guessing_game(num):
    guessed_right = False
    count = num
    for _ in range(num):
        print(f"You have {count} attempts remaining to guess the number.")
        count -= 1
        guess = int(input("Make a guess: "))
        guess_func = guess_number(guess)
        if guess_func == 0:
            print(f"You got it! The answer is {guess}")
            break
    if guess_func != 0:
        print("You've run out of guesses, you lose.")


print("Welcome to the Number Guessing Game!")
print("I'm thinking of a number between 1 and 100.")
choice = input("Choose a difficulty. Type 'easy' or 'hard': ")

if choice == 'easy':
    num = 10
    guessing_game(num)

elif choice == 'hard':
    num = 5
    guessing_game(num)
else:
    print("Incorrect Value")
