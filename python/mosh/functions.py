'''
#Two type of functions:
#1. Carries out a task (print)
#2. Returns a value (return)

def greet(myName):
    print(f"Yer {myName}")

print(greet("Mosh"))
#This will return none by default, all functions default to none if nothing is provided)

def get_greeting(myName):
    return f"Yer {myName}"

message = get_greeting("faisal")
file = open("content.txt", "w")
file.write(message)

#by=2 is a keyword argument
def increment(number, by):
    return number + by

print(increment(1, by=2))


# making parameters in functions optional:


def increment(number, by):
    result = return number + by
    print(result)
    
increment(2,1)


#Parameter is the input you declare for your function: Ex. first_name
def greet(first_name, last_name):
    print(f"{first_name} {last_name}")
    print("Welcome aboard")
    
#Argument is is the value you give for your parameter in the function. Ex. Name of person    
greet("Faisal", "Hashem")
greet("Farzana", "Hashem")

#defaulting to a certain argument
def increment(number, by=2, test=8):
    return number + by + test

print(increment(5))


#xargs: not using set numbers in the function
def multiply(*numbers):
    total = 1
    for number in numbers:
        total *= number
    return total

print(multiply(2, 3, 4, 5))


#Exporting dictionary

def save_user(**user):
    print(user) #can change value to call values from different keys. 
    
save_user(id=12, name="Faisal", age=22)


def multiply(*numbers):
    total = 1
    for number in numbers:
        total *= number
    return total

print("Start")
print(multiply(1, 2, 3))


'''
# Exercise FizzBuzz
# fizz_buzz function:
# If divisible by 3, return Fizz
# If divisible by 5, return Buzz
# If divisible by 5 & 3, return FizzBuzz
# If divisible by anything else, return its number


def fizzbuzz(input):
    if (input % 3 == 0) and (input % 5 == 0):
        return "FizzBuzz"
    if input % 3 == 0:
        return "Fizz"
    if input % 5 == 0:
        return "Buzz"
    return input


print(fizzbuzz(14))
