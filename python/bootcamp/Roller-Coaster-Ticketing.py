print("Welcome to Kinga Ka")
height = int(input("What is your height?\n"))
bill = 0

if height > 120:
    print("You can ride")
    age = int(input("What is your age?\n"))
    if age < 12:
        bill = 5
        print("You will be charge $5\n")
    elif age <= 18:
        bill = 7
        print("You will be charged $7\n")
    elif age >= 45 and age <= 55:
        print("Its okay, this is on us")
    else:
        bill = 12
        print("You will be charged $12\n")

    want_photo = input("Do you want a photo? (Y or N)\n")
    if want_photo == "Y":
        bill += 3

    print(f"Your total bill is: {bill}")

else:
    print("You cannot ride Kingda Ka")
