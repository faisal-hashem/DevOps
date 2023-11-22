# Perform Random switch without using random choice function
import random
names_string = "Angela, Ben, Jenny, Michael, Chloe"
names = names_string.split(", ")

len_names = len(names)
random_int = random.randint(0, (len_names - 1))
random_name = names[random_int]

print(f"{random_name} is going to buy the meal today!")
