from turtle import Screen, Turtle
import random

screen = Screen()
turtle = Turtle()
turtle.hideturtle()

colors = ['cyan', 'khaki', 'spring green',
          'crimson', 'medium slate blue', 'dark cyan']


# def draw_angle(num_sides):
#     angle = 360.0 / num_sides
#     for _ in range(num_sides):
#         turtle.right(angle)
#         turtle.forward(100)


# for _ in range(3, 11):
#     turtle.color(random.choice(colors))
#     draw_angle(_)

count = 0
while count < 51:
    count += 1
    if (-300 < turtle.xcor() < 300) and (-300 < turtle.ycor() < 300):
        turtle.right(random.randint(0, 360))
        distance = random.randint(30, 100)
        turtle.forward(distance)
    else:
        turtle.right(180)
        turtle.forward(distance)

screen.exitonclick()
