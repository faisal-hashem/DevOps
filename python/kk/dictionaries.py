#Tuples - immutable data that cannot be changed
tuple1 = (1, 2, 3, 4, 5, 6)
print(tuple1[0]) #prints 1

#tuple1.append(7) # does not work

#Tuple can include various types of values
tuple2 = (1, "John", (1,2))
print(tuple2)
tuple3 = (1,)
print(tuple3)

tuple4 = (1, 2, 3, 4, 5)
print(tuple4)

#collections of data are stored lists, sets, dictionaries, and tuples

#Dictionaries are data types that can be used to store key-value pairs

usernames = {
    "John": "Johnson",
    "Jane": "Doe",
    "Mary": "Smith"
}

print(usernames["John"])

#Built-in methods for Dictionaries

#dictionary.keys()
#dictionary.values()
#dictionary.items()
#dictionary.get()

print(usernames.keys())
for key in usernames.keys():
    print(key + "--" + usernames[key])
    
print(usernames.values())

print(usernames.items()) #returns a list of tuples

#changing a value in a dictionary
usernames["Jane"] = "GIJane"
print(usernames)

#add new values to a dictionary
usernames.update ({"Tomas": "Butterjack"})
print(usernames.items())

#delete a value from a dictionary
del usernames["Mary"]
print(usernames.items())

#remove all values from a dictionary
usernames.clear()
print(usernames.items())

#remove last value from a dictionary
usernames.popitem()
print(usernames.items())

#copying a dictionary
usernames_copy = usernames.copy()
print(usernames_copy.items())
usernames_copy.clear()
print(usernames_copy.items())