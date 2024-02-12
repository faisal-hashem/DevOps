#Practice using Lists
line1 = ["⬜️","️⬜️","️⬜️"]
line2 = ["⬜️","⬜️","️⬜️"]
line3 = ["⬜️️","⬜️️","⬜️️"]
map = [line1, line2, line3]
print("Hiding your treasure! X marks the spot.")
print("ex: Enter A1 for box 1:1")
position = input() 

input = position[0]
list = ["A", "B", "C"]
index = list.index(input)
num_index = int(position[1]) - 1
map[num_index][index] = "X"

print(f"{line1}\n{line2}\n{line3}")
