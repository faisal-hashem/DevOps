import random 

# Rock
rock = """
    _______
---'   ____)
      (_____)
      (_____)
      (____)
---.__(___)
"""

# Paper
paper = """
     _______
---'    ____)____
           ______)
          _______)
         _______)
---.__________)
"""

# Scissors
scissors = """
    _______
---'   ____)____
          ______)
       __________)
      (____)
---.__(___)
"""

my_choice = int(input("What do you choose? Type 0 for Rock, 1 for Paper or 2 for Scissors.\n"))

if my_choice >= 3 and my_choice < 0:
    print(f"{my_choice} is an invalid number")
else:
    choice = [rock, paper, scissors]
    computer_choice = random.choice(choice)
    my_choice_index = choice[my_choice]
    print(my_choice_index)
    print("Computer chose:")
    print(computer_choice)

    if my_choice == 0:
        if computer_choice == choice[1]:
            print("You lose")
        elif computer_choice == choice[2]:
            print("You win")
        else:
            print("This is a Draw")
            
    elif my_choice == 1:
        if computer_choice == choice[0]:
            print("You win")
        elif computer_choice == choice[2]:
            print("You lose")
        else:
            print("This is a Draw")

    elif my_choice == 2:
        if computer_choice == choice[0]:
            print("You lose")
        elif computer_choice == choice[1]:
            print("You win")
        else:
            print("This is a Draw")