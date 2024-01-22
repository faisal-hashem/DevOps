import csv

def log_file_analyzer(filename, keyword):
    with open(filename, "r") as f:
        lines = f.readlines()
        
    line_items = " " 
    for i in lines:
        if i.__contains__(keyword):
            line_items += i
    print(line_items)
    
    new_lines = line_items.split('\n')
    
    csvfile = "output.csv"
    
    output_data = [ ]
    for c in new_lines:
        parts = c.split(' ')
        timestamp = parts[0] + ' ' + parts[1]
    print(timestamp)
        
    
    # with open(csvfile, 'w', newline='') as file:
    #     writer = csv.writer(file)
    #     writer.writerow(output_data)
        
            

# def export_file_to_csv(filename, keyword):
#     with open(filename, "r") as f:
#         lines = f.readlines()
    
#     for i in lines:
#         if i.__contains__(keyword):
#             export_csv(i, keyword)
#         else:
#             print("Cannot be exported")

print("This is a Log File Analyzer, you can search a file with a keyword.")        
file_input = str(input("Enter the file you want to scan: "))    
keyword_input = str(input("Enter the keyword: "))        
log_file_analyzer(file_input, keyword_input)

export_csv = (input("Do you want to export, enter 'y' or 'n' to export: "))
if export_csv == "y":
    export_file_to_csv(file_input, keyword_input)
else:
    print("Goodbye")