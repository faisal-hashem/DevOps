from menu import Menu, MenuItem
from coffee_maker import CoffeeMaker
from money_machine import MoneyMachine

m = Menu()
money = MoneyMachine()
coffee = CoffeeMaker()
mitem = MenuItem

coffe_machine_on = True

while coffe_machine_on:
    choice = input(f"What would you like? {m.get_items()}:")
    if choice == "report":
        coffee.report()
    elif choice == "off":
        break
    else:
        drink_choice = m.find_drink(choice)
        sufficient = coffee.is_resource_sufficient(drink_choice)
        print(sufficient)
        
