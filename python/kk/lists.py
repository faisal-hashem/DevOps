'''
#Basic Lists

countries = ['Australia', 'Canada', 'France', 'Germany', 'India', 'Japan', 'USA', 'Cuba']
countries[0] = 'UK'
print(countries[0])
print(len(countries)) #print the length of the list

del countries[0] #removes the first element from the list
print(countries)
print(countries[-1]) #returns the last element of the list

print(countries[::-1]) #returns the list in reverse order
print(countries[1:]) #returns the rest of the elements of the list
print(countries[:]) #returns the first element of the list
print(countries[1:3]) #returns the first 2 elements of the list
print(countries[::3]) #returns every third element of the list

#Lists Methods
countries.append('China') #adds an element to the end of the list
countries.insert(0, 'China') #adds an element to the beginning of the list
countries.insert(2, 'China') #adds an element to the middle of the list
countries.remove('China') #removes an element from the list
countries.pop() #removes the last element of the list
countries.pop(0) #removes the first element of the list
countries.sort() #sorts the list

#swap values in the list
countries[0], countries[1] = countries[1], countries[0]
print(countries)

countries.sort() #modifies the original list - using countries, it will sort in alphabetical order
print(countries)

countries.reverse() #reverses the list
print(countries)
print(min(countries))
'''
'''
#for loop iteration for averages
total = 0
ages = [20, 30, 40, 50, 60]
for age in ages:
    total += age
average = total / len(ages)
print(average)

#it is printed 4 times for each value in the list
for x in [0, 2, 1, 3]: 
    for y in [0, 4, 1, 2]: #this prints 4 times for each value in the list, multiply that by each value in the first list
            print('*') 


#list slicing
#number variables reference the same memory location as the list

age = [20, 30, 40, 50, 60]
age2 = age
age2[0] = 10 #this will also change age[0] to 10
print(age)
print(age2)
#slicing the list can fix this issue
age2 = age[:]
age2[0] = 11
print(age2)

#prints list with index
list1 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
for index, j in enumerate(list1):
     print(index, j)
     
#Slicing the list
print(age[::-1])
print(list1[0:9])
print(list1[1:-1])
print(list1[:8])
print(list1[8:])

#finding in lists
print(20 in age)
print(20 not in age)
print(20 in age2)
print(20 not in age2)

#replace fields in lists
list1 = [0, 3, 4, 1, 2]
list1[2:5]=[8,9]
print(list1)

#matrix lists 2D array
classroom = [
    ["Samith", "John", "Michael"],
    ["Anthony", "Brian", "Joseph"],
    ["Jonathan", "Michael", "Joseph"],
    ["John", "David", "Joshua"],
]
print(classroom[2][1]) #prints Michael

#Ex 1
a = []
for i in range(2): # Loops through twice 0 and then 1.
    a.append([]) # created 2 lists inside of a list
    for j in range(2): #runs this twice, first time adds 0 and second time adds 1.
        a[i].append(j) # [0,1]

print(a)

#Breakdown: 
#First iteration i is 0 in the outer loop. 
    #First iteration of inner loop j is 0 in the inner loop. 
    #Second iteration j is 1 in the inner loop.
        #
#Second iteration i is 1 in the outer loop. 
    #First iteration of inner loop j is 0 in the inner loop. 
    #Second iteration j is 1 in the inner loop.
        #i equals 1 now and it gets replaced by 0 first loop of inner loop
        #withing the second loop of inner loop, i=1 gets replaced by j=1.
        # which in return makes it [0,1]

#Ex2         
a = []
for i in range(5):
    a.append([])
    for j in range(5):
        a[i].append(j)

print(a)

#Ex3
#creating a 4x4 matrix
matrix = [[j for j in range(4)] for i in range(4)]
print(matrix)

#Ex4
#comibing multiple lists in matrix into a single list
matrix = [[0, 1, 2], [0, 1, 2], [0, 1, 2]]

matrix2 = []

for submatrix in matrix:
  for val in submatrix:
    matrix2.append(val)
    
print(matrix2)

#Ex5
countries = [['Egypt', 'USA', 'India'], ['Dubai', 'America', 'Spain'], ['London', 'England', 'France']]
countries2  = [country for sublist in countries for country in sublist if len(country) < 4]
print(countries2) #prints USA
'''

#3D Matrix List

school = [[
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9]
],
[
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9]
],
[
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9]
]]

#converts to a 2D matrix
matrix = []

for submatrix in school:
    for row in submatrix:
        matrix.append(row)

print(matrix)
print(matrix[2][2]) #prints 9


matrix = [[[k for k in range(3)] for j in range(3)] for i in range(3)]
print(matrix)

[0,1,2]
[0,1,2]
[0,1,2]