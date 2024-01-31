import random
from data import data
from art_logo import logo, vs

def get_random_data():
    #Get name description
    random_data = random.choice(data)
    return random_data

compare_a = get_random_data()
compare_a_name = compare_a["name"]
compare_a_description = compare_a["description"]
compare_a_country = compare_a["country"]
compare_a_followers = compare_a["follower_count"]

compare_b = get_random_data()
compare_b_name = compare_b["name"]
compare_b_description = compare_b["description"]
compare_b_country = compare_b["country"]
compare_b_followers = compare_b["follower_count"] 

print(logo)
#print name, description, country
print(f"Compare A: {compare_a_name} , a {compare_a_description}, from {compare_a_country}.")
print(vs)
#print name, description, country
print(f"Against B: {compare_b_name} , a {compare_b_description}, from {compare_b_country}.")
choice = input("Who has more followers? Type 'A' or 'B': ")

#compare     
def compare(choice):
    if choice == 'A':
        compare_a_followers > compare_b_followers:
            
            
# def score()   

# print(data[0]["name"])
# print(data[0]["country"])
# print(data[0]["description"])
# print(data[0]["follower_count"])