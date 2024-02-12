import os
os.system('cls' if os.name == 'nt' else 'clear')
from art import logo

def add(n1, n2):
    return n1 + n2

def subtract(n1, n2):
    return n1 - n2

def multiply(n1, n2):
    return n1 * n2

def divide(n1, n2):
    return n1 / n2

def calculator():
    print(logo)
    num1 = float(input("What's the first number?: "))
    should_continue = True
    
    while should_continue:
        operators = {
            "+": add,
            "-": subtract,
            "*": multiply,
            "/": divide,
        }
        
        for i in operators:
            print(i)
            
        choice = input("Pick an operation: ")
        num2 = float(input("What's the next number?: "))
    
        calculation = operators[choice]
        answer = calculation(num1, num2)
    
        print(f"{num1} {choice} {num2} = {answer}")
        
        response = input(f"Type 'y' to continue calculating with {answer} or type 'n' to exit: ")
        
        if response == 'n':
            os.system('clear')
            calculator()
        else:
            num1 = answer
            
calculator()
        
            
        
    