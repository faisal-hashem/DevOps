print("Welcome to Faisal's Pizza Bella\n")
pizza_size = input("What size pizza do you want? 'S' 'M' 'L' \n")
bill = 0
if pizza_size == 'S':
    bill = 15
    print("Your Pizza is $15\n")
elif pizza_size == 'M':
    bill = 20
    print("Your Pizza is $20\n")
elif pizza_size == 'L':
    bill = 25
    print("Your Pizza is $25\n")

pepperoni = input("Do you want Pepperoni? 'Y' or 'N' \n")
if pepperoni == 'Y' and pizza_size == 'S':
    bill += 2
    print("Pepperoni will add extra $2 on a Small Pizza")
elif pepperoni == 'Y' and (pizza_size == 'M' or pizza_size == 'L'):
    bill += 3
    print("Pepperoni will add extra $3 on a Medium or Large Pizza")

cheese = input("Do you want extra cheese? 'Y' or 'N' \n")
if cheese == 'Y':
    bill += 1

print(f"Your total bill is: {bill}")
