def tip_calculator():
    print("Welcome to the Tip Calculator! \n")
    total_bill = float(input("What was the total bill? $"))
    people = int(input("How many people to split the bill?"))
    percentage = int(
        input("What percentage tip would you like to give? 10, 12, or 15?"))
    tip_amount = round(
        (((total_bill * (percentage/100)) + total_bill) / people), 2)
    final_tip_amount = "{:.2f}".format(tip_amount)
    print(f"Each person should pay: $ {final_tip_amount}")


tip_calculator()
