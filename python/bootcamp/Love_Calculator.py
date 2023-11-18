print("The Love Calculator is calculating your score...")
name1 = input()  # What is your name?
name2 = input()  # What is their name?

full_name = name1 + name2
lower_name = full_name.lower()
true_amount = lower_name.count(
    't') + lower_name.count('r') + lower_name.count('u') + lower_name.count('e')
love_amount = lower_name.count(
    'l') + lower_name.count('o') + lower_name.count('v') + lower_name.count('e')
truelove_num = str(true_amount) + str(love_amount)
int_truelove_num = int(truelove_num)

# print(int_truelove_num)

if int_truelove_num < 10 | int_truelove_num > 90:
    print(f"Your score is {
          int_truelove_num}, you go together like coke and mentos.")
elif 40 < int_truelove_num < 50:
    print(f"Your score is {int_truelove_num}, you are alright together.")
else:
    print(f"Your score is {int_truelove_num}.")
