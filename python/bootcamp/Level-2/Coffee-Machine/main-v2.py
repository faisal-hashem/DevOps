from menu import Menu, MenuItem
from coffee_maker import CoffeeMaker
from money_machine import MoneyMachine

menu = Menu()
coffee_maker = CoffeeMaker()
money_machine = MoneyMachine()

is_on = True
while is_on:
    choice = input(f"Please select one: {menu.get_items()}: ")
    if choice == "report":
        coffee_maker.report()
        money_machine.report()
    elif choice == "off":
        is_on = False
    else:
        drink = menu.find_drink(choice)
        cost = drink.cost
        if coffee_maker.is_resource_sufficient(drink) and money_machine.make_payment(cost):
            coffee_maker.make_coffee(drink)
