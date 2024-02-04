from data import MENU, resources
money = 0


def coins():
    """Returns total calculated from coins inserted"""
    print("Please insert coins.")
    total = (int(input("how many quarters?: "))) * .25
    total += (int(input("how many dimes?: "))) * .10
    total += (int(input("how many nickles?: "))) * .05
    total += (int(input("how many pennies?: "))) * .01
    return total


def validate(choice):
    """Validates if there are enough resources and returns a True/False"""
    stock = MENU[choice]["ingredients"]
    for i in stock:
        if stock[i] > resources[i]:
            print(f"Sorry there is not enough {i}")
            return False
    return True


def menu(choice):
    """Pulls Menu from Dictionary"""
    if choice == "espresso":
        co_water = MENU[choice]['ingredients']['water']
        co_milk = 0
        co_coffee = MENU[choice]['ingredients']['coffee']
        co_cost = MENU[choice]['cost']
        return co_water, co_milk, co_coffee, co_cost
    else:
        co_water = MENU[choice]['ingredients']['water']
        co_milk = MENU[choice]['ingredients']['milk']
        co_coffee = MENU[choice]['ingredients']['coffee']
        co_cost = MENU[choice]['cost']
        return co_water, co_milk, co_coffee, co_cost


def cashier():
    """Processes change after coins are inserted"""
    money = 0
    customer_cash = coins()
    item_cost = MENU[choice]["cost"]
    if customer_cash >= item_cost:
        change = round((customer_cash - item_cost), 2)
        money += item_cost
        return money, change
    else:
        return 0


coffee_power_on = True
while coffee_power_on:
    choice = input("What would you like? (espresso/latte/cappuccino): ")

    if choice == "report":
        print(f"Water: {resources['water']}ml")
        print(f"Milk: {resources['milk']}ml")
        print(f"Coffee: {resources['coffee']}g")
        print(f"Money: ${money}")
    elif choice == "off":
        coffee_power_on = False
    elif choice not in ("espresso", "latte", "cappuccino"):
        print(f"{choice} is an invalid entry. Please try again.")
    elif validate(choice):
        item = menu(choice)
        transaction = cashier()

        if transaction == 0:
            print("Sorry that's not enough money. Money refunded.")
        else:
            money = transaction[0]
            change = transaction[1]
            print(f"Here is ${change} in change")
            print(f"Here is your {choice}. Enjoy!")
            resources['water'] -= item[0]
            if "milk" in MENU[choice]['ingredients']:
                resources['milk'] -= item[1]

            resources['coffee'] -= item[2]
