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


def cashier(choice, money):
    if choice == "espresso":
        if money >= MENU[choice]['cost']:
            change = money - MENU[choice]['cost']
            return change
        else:
            print("Sorry that's not enough money. Money refunded.")


def menu(choice):
    if choice == "espresso":
        co_water = MENU[choice]['ingredients']['water']
        co_coffee = MENU[choice]['ingredients']['coffee']
        co_cost = MENU[choice]['cost']
        return co_water, co_coffee, co_cost
    else:
        co_water = MENU[choice]['ingredients']['water']
        co_milk = MENU[choice]['ingredients']['milk']
        co_coffee = MENU[choice]['ingredients']['coffee']
        co_cost = MENU[choice]['cost']
        return co_water, co_milk, co_coffee, co_cost


# choice = input("What would you like? (espresso/latte/cappuccino): ")
choice = "latte"
item = menu(choice)
print(item[0])

if water > item[0]:
    water -= item[0]
else:
    print("Sorry there is not enough water.")

if milk > item[1]:
    milk -= item[1]
else:
    print("Sorry there is not enough milk.")

if coffee > item[2]:
    coffee -= item[2]
else:
    print("Sorry there is not enough coffee.")

# money += coins()
# coffee(money, choice)
