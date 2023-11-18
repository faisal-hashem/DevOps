#Modules make python code easier to read and use. You can import them like this:

#Not the recommended way of importing modules.
import math #This will NOT get imported into your code. 

print(math.sin(90))
print(math.pi)

#using your own sin function.
def sin(x):
    if 2 * x == pi:
        return 0.99999
    else:
        return None
pi = 3.14

#showing difference between the recommended way of importing modules and using your own sin function.
print(sin(pi/2))
print(math.sin(math.pi/2))

#recommended way of importing modules.
import math as m #This will get imported into your code. 

print(m.pi)
print(m.sin(90))

#recommended way of importing modules.
from math import pi as p, sin as s #This will get imported into your code. 

print(p)
print(s(90))

#how to check all the entities of a module. 

print(dir(math))

#useful modules:
#Random Floats
from random import random #used to generate float values between 0 and 1.
print(random()) 

#Random Integers
from random import randint #used to generate integer values between 0 and 100.

for i in range(10):
    print(randint(0,100)) #genereate random integers between 0 and 100 10 times.
    
#Random Choice and Sampling
from random import choice, sample #used to generate random values from a list.
students = ['John', 'Mary', 'Sarah', 'Michael']

print(sample(students, 2)) #generate a random student from the list.
print(choice(students)) #generate a random student from the list.

from random import seed #used to set the random seed.