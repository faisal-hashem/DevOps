def bmi_calculator():
    height = float(input("What is your Height in meters? "))
    weight = float(input("What is your Weight in pounds? "))
    bmi = weight / height ** 2
    return print(f"Your BMI is: {bmi}")


bmi_calculator()
