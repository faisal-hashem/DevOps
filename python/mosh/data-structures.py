'''
# Lists:

letters = ["a", "b", "c"]
matrix = [[1,2], [2,3]]
zeros = [0] * 5
combined = zeros + letters #0,0,0,...a,b,c
numbers = list(range(20)) # 1,2..20
chars = list("Hello World")
letters[0] = "A" #modify list items
#print(letters[0]) #print list item selection

print(letters[0:2]) #or print(letters[:2])

#print every other number in the original list
numbers = list(range(20))
print(numbers[::2])
print(numbers[::-1]) #in reverse order

#Unpacking items on the list to separate variables
numbers = [1,2,3,98]
#hello, bai, jaan = numbers

#print(jaan) #gives you 3

#or if you want to unpack outside of the first 2 in the list

hello, *other, last = numbers #similar to def multiply(*other)
print(other)



#Use for loops to iterate over lists:
letters = ["a","b","c"]
for indexnum, letter in enumerate(letters):
    print(indexnum, letter)


# Modifying items on a list
letters = ["a", "b", "c"]

letters.append("e")  # Adding = use Append method
letters.insert(0, "d")  # insert by index
letters.pop(2)  # remove by index
letters.remove("c")  # remove by value
del letters[0:1]  # delete by index range or index
letters.clear()  # clear all
print(letters)

# Addin in between = use Insert Method


letters = ["a", "b", "b", "c"]

print(letters.index("c"))  # find the index number of value
print(letters.count("b"))  # find the number of values that exists in this list


# sorting a list
letters = ["a", "b", "b", "c"]
letters.sort()  # accending order
letters.sort(reverse=True)  # descending order
# print(letters)

numbers = sorted(letters)  # accending
numbers = sorted(letters, reverse=True)  # descending
# print(numbers)


# Sorting Tuples 

#not the best way but works.
items = [
    ("Product1", 10),
    ("Product2", 9),
    ("Product3", 12)
]


def sort_item(item):
    return item[1]


items.sort(key=sort_item)
print(items)

# better way is using Lambda functions
items = [
    ("Product1", 10),
    ("Product2", 9),
    ("Product3", 12)
]

#(key=lambda parameters:expressions)
items.sort(key=lambda item: item[1])
print(items)


#Transform current tuple list into a numbers list only. Not the best way
items = [
    ("Product1", 10),
    ("Product2", 9),
    ("Product3", 12)
]

prices = []

for item in items:
    prices.append(item[1])

print(prices)


# Transform tuple to a map of numbers only:

items = [
    ("Product1", 10),
    ("Product2", 9),
    ("Product3", 12)
]

items_2 = [
    ("ProductX", 2),
    ("ProductY", 3),
    ("ProductZ", 5)
]

prices = list(map(lambda item: item[1], items_2))
# item:item[1] this is any variable name, it is used to grab each line item in the list. [1] the index to sort by
# items_2 - this is how lambda function knows what list to use
# use list () since the map() will just bring in a map object.

print(prices)
'''
