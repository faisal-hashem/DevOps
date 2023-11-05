'''
# Exceptions can be handled by using try-except-finally blocks

try:
    name = 'Lydia'
    print('My name is ' + name)
except:
    print('Something went wrong')

print("All Done!")

# Managing Zero Division Error and Value Error or others
try:
    x = int(input("Enter a number: "))
    y = 1 / x
    print(y)
except ZeroDivisionError:
    print("Cannot divide by zero")
except ValueError:
    print("Not a number")
except:
    print("Something else went wrong")

#can also use base exceptions instead of zero division error

try:
    y = 5 / 0
except BaseException:
    print("Can't divide with zero.")    

#unnamed exceptions run only when it is the only exception and when there is no dedicated exception

flowers = ['roses', 'daisies', 'dahlias', 'camellias']
i = 0
while True:
    try:
        print(flowers[i])
        i += 1
    except IndexError:
        break

# hierarchical exceptions can be used to handle exceptions in nested functions
#LookupError includes: KeyError and IndexError
#ArithmeticError includes: ZeroDivisionError
#ValueError includes: TypeError
#Similar between ArithmeticError and Assertion Error is that they both are stemmed from Exceptions

flowers = ['roses', 'daisies', 'dahlias', 'camellias']
i = 0
while True:
    try:
        print(flowers[i])
        i += 1
    except LookupError:
        break

# Errors can be handles inside functions


def calculate_user_input():
    try:
        x = int(input("Enter a number: "))
        y = 1 / x
        print(y)
    except ZeroDivisionError:
        print("Cannot divide by zero")
    except:
        print("Something else went wrong")

    return None


calculate_user_input()

# Errors can also be handled outside of functions like this:


def calculate_user_input():
    x = int(input("Enter a number: "))
    y = 1 / x
    print(y)
    return None


try:
    calculate_user_input()
except ZeroDivisionError:
    print("Cannot divide by zero")
except:
    print("Something else went wrong")
    

# Raising exceptions can be handled by using try-except-finally blocks:


def calculate_user_input():
    try:
        x = int(input("Enter a number: "))
        y = 1 / x
        print(y)
    except:
        print("Something else went wrong")
        raise

    return None


calculate_user_input()

# assertion Errors are useful for math functions that need to be checked before they can be executed.

import math

x = int(input("Enter a number: "))
assert x >= 0

x = math.sqrt(x)
print('Result:', x)

#Abstract exceptions are used to handle exceptions in nested functions.
'''

a = input("Enter a number: ")
try:
    float(a) / 0
except (TypeError, ZeroDivisionError):
    print("Please enter valid numbers, besides 0.")
