from turtle import Screen, Turtle
import random

screen = Screen()
turtle = Turtle()
turtle.hideturtle()
screen.colormode(255)

def random_color():
    r = random.randint(0, 255)
    g = random.randint(0, 255)
    b = random.randint(0, 255)
    random_color = (r,g,b)
    return random_color

directions = [0, 90, 180, 270]
random_move = [turtle.forward(15), turtle.backward(15)]

turtle.speed("fastest")
turtle.pensize(8)
for _ in range(200):
    turtle.pencolor(random_color())
    turtle.forward(15)
    turtle.setheading(random.choice(directions))
        
screen.exitonclick()