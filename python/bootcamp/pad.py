user_starter_cards = [11, 10, 12]

for i in user_starter_cards:
    if i == 11:
        if sum(user_starter_cards) > 21:
            index = user_starter_cards.index(i)
            user_starter_cards[index] = 1
            print(user_starter_cards)
        elif 10 < sum(user_starter_cards) < 21:
            user_starter_cards.index(i) == 1


# index = list.index(input)
# num_index = int(position[1]) - 1
# map[num_index][index] = "X"
        