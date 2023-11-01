'''
#if/else statements
if "bag" > "faisal":
    print("hello bro")
else:
    print("nah its all Faisal")
*/


# For Loops
for number in range(1, 10, 2):
    print("Attempt", number, number * ".")

#For/Else 
Successful = False
for number in range(3):
    print("Attempting" + (number * "."))
    if (Successful):
        print ("That was successful")
        break
else:
    print("That was not successful")
 
#Nested Loops
for y in range(3):
    for x in range(6):
        print(f"({y},{x})")

#Type
print(type(5))
print(type(range(5)))

#Iterable:
for character in "Python":
    print(character)
 
#While Loops:
number = 100
while number > 0:
    print(number)
    number //= 2
  
#While Loop Ex 2:
command = ""
while command.lower() != "quit":
    command = input (">")
    print("ECHO", command)

 
 #infinite Loops
while True:
    command = input(">")
    print("ECHO", command)
    if command.lower() == "quit":
        break
        
#Exercise to display Even Numbers after 10
number = 2
while number < 10:
    print(number)
    number += 2
print("We have 4 even numbers")
'''
# OR use this method:
count = 0
for number in range(1, 10):
    if number % 2 == 0:  # this is another way of specifying EVEN numbers
        count += 1
        print(number)
print(f"We have {count} even numbers")
