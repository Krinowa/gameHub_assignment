extends Node

# Total count of collected items
var total_collected_items = 0

# Singleton function to add to the total count
func add_collected_item():
	total_collected_items += 1
	print("Total collected items: ", total_collected_items)
