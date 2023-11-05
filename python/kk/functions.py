'''
#run function overtaking default values
def print_info(name, age=18):
    print(name, age)

print_info('john', 19)

#get input
def get_num():
    return int(input())

int = get_num()
print(int)

#math function

def multi_num(number):
    return int(input()) * number

print(multi_num(5))

nums= [7,4,1]
def change_third_item(list):
	list[2] = 5

change_third_item(nums)
print(nums)


def list_func(list):
    mylist = []
    for i in list:
        mylist.append(i * 2)
    return mylist

print(list_func([1, 2, 3]))

#List Comprehension
#If 6 % 2 = 0, the boolean value is False, thats why the following will return odd numbers
def get_odd_func(numbers):
    odd_numbers = [num for num in numbers if num % 2]
    return odd_numbers

print(get_odd_func([7, 4, 5, 6, 9, 8, 12]))

#print even numbers
def get_even_func(numbers):
    even_numbers = [num for num in numbers if not num % 2]
    return even_numbers

print(get_even_func([7, 4, 5, 6, 9, 8, 12]))

#Multiply 2 lists to get 1 list
def double_list(numbers):
  return 2 * numbers

numbers = [1, 2, 3]
print(double_list(numbers))



#Scopes
#Variables are only within the function
#use global var_name if you want to use it outside of the function

#arguments

#when using a function to change a integer value to a string, the original value remains the same
#when using a function to change a list value to something else list[0] = 10, the original value of the list is also modified.

def my_function(*ages):
  print("The older friend is " + ages[0] + " years")

my_function("13", "12", "11")
'''
