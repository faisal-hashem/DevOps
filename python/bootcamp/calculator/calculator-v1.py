from art import logo, operations
print(logo)

def add(a1, a2):
  add_output = a1 + a2
  print(f"{a1} + {a2} = {add_output}")
  return add_output

def subtract(s1, s2):
  sub_output = s1 - s2
  print(f"{s1} - {s2} = {sub_output}")
  return sub_output

def multiply(m1, m2):
  multi_output = m1 * m2
  print(f"{m1} + {m2} = {multi_output}")
  return multi_output

def divide(d1, d2):
  div_output = d1 / d2
  print(f"{d1} + {d2} = {div_output}")
  return div_output

loop = True
number = 0
first_num = 0
while loop:
  if number != 0:
    first_num = number
    next_num = float(input("What's the next number?: "))
    print(operations)
    op = input("Pick an Operation: ")
    number = 0
  else:
    first_num = float(input("What's the first number?: "))
    next_num = float(input("What's the next number?: "))
    print(operations)
    op = input("Pick an Operation: ")
  
  if op == "+":
    value = add(first_num, next_num)
    number += value
    print(value)
  elif op == "-":
    value = subtract(first_num, next_num)
    number += value
    print(value)
  elif op == "*":
    value = multiply(first_num, next_num)
    number += value
    print(value)
  elif op == "/":
    value = divide(first_num, next_num)
    number += value
    print(value)
  else:
    print("That is a incorrect operation")
    break

  loop = input(f"Type 'y' to continue calculating with {number}, or type 'n' to start a new calculation: ")

  if loop == "n":
    print("Goodbye!")
    loop = False
