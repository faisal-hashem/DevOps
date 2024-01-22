import csv

# Let's assume this is your terminal output, a list of lists
output_data = [
    ['Name', 'Age', 'City'],
    ['Alice', 30, 'New York'],
    ['Bob', 25, 'Los Angeles'],
    ['Charlie', 35, 'Chicago']
]

# Specifying the filename
filename = "output.csv"

# Writing to the csv file
with open(filename, 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerows(output_data)

print(f"Data exported to {filename}")