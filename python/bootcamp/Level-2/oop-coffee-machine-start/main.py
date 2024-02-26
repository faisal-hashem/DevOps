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
        money.report()
    elif choice == "off":
        coffe_machine_on = False
    else:
        drink_choice = m.find_drink(choice)
        sufficient = coffee.is_resource_sufficient(drink_choice)
        if sufficient:
            drink_cost = drink_choice.cost
            if money.make_payment(drink_cost):
                coffee.make_coffee(drink_choice)
