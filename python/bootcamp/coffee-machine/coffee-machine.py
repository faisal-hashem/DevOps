from data import MENU, resources


water = resources["water"]
milk = resources["milk"]
coffee = resources["coffee"]
money = 0


def coins():
    print("Please insert coins.")
    quarters = (int(input("how many quarters?: "))) * .25
    dimes = (int(input("how many dimes?: "))) * .10
    nickles = (int(input("how many nickles?: "))) * .05
    pennies = (int(input("how many pennies?: "))) * .01
    total = quarters + dimes + nickles + pennies
    return total


# def cashier(choice, money):
#     if choice == "espresso":
#         if money >= MENU[choice]['cost']:
#             change = money - MENU[choice]['cost']
#             return change
#         else:
#             print("Sorry that's not enough money. Money refunded.")

def validate_inventory(choice):
    # Get the required ingredients for the chosen drink
    stock = MENU[choice]["ingredients"]

    for ingredient, amount_required in stock.items():
        if resources[ingredient] >= amount_required:
            continue  # Enough of this ingredient
        else:
            print(f"Sorry, there is not enough {ingredient}.")
            return False  # Not enough of this ingredient

    return True  # Enough of all ingredients


choice = "latte"
if validate_inventory(choice):
    print(f"Enough resources for {choice}")
else:
    print(f"Not enough resources for {choice}")

# def validate_inventory(choice, water, milk, coffee):
#     resources = [water, milk, coffee]
#     stock = MENU[choice]["ingredients"]
#     for i in stock.values():
#         for r in resources:
#             if i > r:
#                 continue
#             else:
#                 print("Missing {stock.keys}")


# def menu(choice):
#     if choice == "espresso":
#         co_water = MENU[choice]['ingredients']['water']
#         co_coffee = MENU[choice]['ingredients']['coffee']
#         co_cost = MENU[choice]['cost']
#         return co_water, co_coffee, co_cost
#     else:
#         co_water = MENU[choice]['ingredients']['water']
#         co_milk = MENU[choice]['ingredients']['milk']
#         co_coffee = MENU[choice]['ingredients']['coffee']
#         co_cost = MENU[choice]['cost']
#         return co_water, co_milk, co_coffee, co_cost


# coffee_power_on = True
# while coffee_power_on:
#     choice = input("What would you like? (espresso/latte/cappuccino): ")

#     if choice == "report":
#         print(f"Water: {water}")
#         print(f"Milk: {milk}")
#         print(f"Coffee: {coffee}")
#         print(f"Money: {money}")
#     elif choice == "off":
#         coffee_power_on = False
#     else:
#         validation = validate_inventory(choice, water, milk, coffee)
#         if validation == 1:
#             item = menu(choice)
#             if choice == "espresso":
#                 item_cost = item[2]
#             else:
#                 item_cost = item[3]

#             if water > item[0]:
#                 water -= item[0]
#             else:
#                 print("Sorry there is not enough water.")

#             if "milk" in MENU[choice]['ingredients']:
#                 if milk > item[1]:
#                     milk -= item[1]
#                 else:
#                     print("Sorry there is not enough milk.")

#             if coffee > item[2]:
#                 coffee -= item[2]
#             else:
#                 print("Sorry there is not enough coffee.")

#             customer_cash = coins()
#             if customer_cash >= item_cost:
#                 change = round((customer_cash - item_cost), 2)
#                 money += item_cost
#                 print(f"Here is ${change} in change")
#                 print(f"Here is your {choice}. Enjoy!")

#             else:
#                 print("Sorry that's not enough money. Money refunded.")
