from turtle import Screen, Turtle

screen = Screen()
turtle = Turtle()
turtle.hideturtle()

num_sides = 3

while num_sides < 9:
    angle = 360.0 / num_sides
    for _ in range(num_sides):
        turtle.right(angle)
        turtle.forward(100)
    num_sides += 1

screen.exitonclick()
