from prettytable import PrettyTable
from prettytable.colortable import ColorTable, Themes

table = PrettyTable()

# table.field_names = ['Pokemon Name', 'Pokemon Type']
# table.add_row(["Pickachu", "Electric"], divider=True)
# table.add_row(["Charmander", "Fire"], divider=True)
# table.add_row(["Squirtle", "Water"], divider=True)
# table.add_row(["Bulbasaur", "Grass"], divider=True)
# table.add_row(["Lugia", "Air"], divider=True)

table.add_column("Pokemon Name", ["Pickachu", "Squirtle", "Charmander", "Bulbasaur"])
table.add_column("Type", ["Electric", "Water", "Fire", "Grass"])
table.align = "l"
table.sortby = "Type"
table.border = True
print(table)

x = ColorTable(theme=Themes.OCEAN)
print(x)