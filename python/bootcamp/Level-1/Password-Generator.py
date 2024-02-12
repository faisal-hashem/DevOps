# Password Generator Project
import random
letters = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y',
           'z', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z']
numbers = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']
symbols = ['!', '#', '$', '%', '&', '(', ')', '*', '+']

print("Welcome to the PyPassword Generator!")
nr_letters = int(input("How many letters would you like in your password?\n"))
nr_symbols = int(input(f"How many symbols would you like?\n"))
nr_numbers = int(input(f"How many numbers would you like?\n"))

non_format_password = ""

for l in range(0, nr_letters + 1):
    l = random.choice(letters)
    non_format_password += l

for s in range(0, nr_symbols + 1):
    s = random.choice(symbols)
    non_format_password += s

for n in range(0, nr_numbers + 1):
    n = random.choice(numbers)
    non_format_password += n

password_list = list(non_format_password)
random.shuffle(password_list)
shuffle_password = ''.join(password_list)

print(f"Here is your password: {shuffle_password}")
