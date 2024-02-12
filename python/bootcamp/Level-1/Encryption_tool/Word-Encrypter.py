from art import logo
import random
alphabet = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y',
            'z', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z']

name = "".join([random.choice(alphabet) for _ in range(10)])
print(name)

#print(logo)


# def ceasar(function, word, shift_amount):

#     if shift_amount > 26:
#         shift_amount = shift_amount % 26

#     new_word = ""
#     for l in word:
#         if l not in alphabet:
#             new_word += l
#         else:
#             letter_index = alphabet.index(l)
#             if function == "encode":
#                 new_index = letter_index + shift_amount
#             elif function == "decode":
#                 new_index = letter_index - shift_amount
#             new_letter = alphabet[new_index]
#             new_word += new_letter
#     print(new_word)


# flag = True
# while flag:
#     direction = input("Type 'encode' to encrypt, type 'decode' to decrypt:\n")
#     text = input("Type your message:\n").lower()
#     shift = int(input("Type the shift number:\n"))

#     ceasar(function=direction, word=text, shift_amount=shift)

#     rerun = input("Do you want to run again?\n")
#     if rerun == "yes":
#         flag = True
#     elif rerun == "no":
#         flag == False
#         print("Goodbye!")
#         break
#     else:
#         print("Not a valid answer!")
#         break
