
extends Node2D

signal cell_pressed(cell)
signal card_played(side, name, cell)
signal unit_rotated(cell, rotation)
signal rotation_complete(cell)
signal unit_removed(cell)

# member variables here, example:
# var a=2
# var b="textvar"
onready var game = get_node("/root/Game")
onready var cells = get_node("Cells")

func _ready():
	connect("cell_pressed", self, "play_card")
	connect("rotation_complete", self, "on_rotation_complete")
	
func play_card(cell):
	print("try play card")
	if cell.hovered_card == null:
		return
	print("plaing card")

	var card = cell.hovered_card
	var hand = card.hand
	var unit = put_unit(cell.side, card.unit_name, cell.get_index())
	
	hand.money.remove_coins(card.cost)
	

	
func put_unit(side, unit_name, index):
	print("put_unit " + str(side) + ", " + str(unit_name) + ", " + str(index))
	var path = "res://units/" + unit_name + ".tscn"
	var unit = load(path).instance()
	var cell = cells.get_child(index)
	unit.set_pos(Vector2(0,0))
	unit.set_unit_name(unit_name)
	unit.set_side(side)
	cell.set_unit(unit)
	emit_signal("card_played", side, unit_name, index)
	return unit
	
func rotate_unit(cell_index, rotation):
	var unit = cells.get_child(cell_index).get_unit()
	if unit != null:
		unit.set_rot(rotation)
	
func stop_game():
	for cell in cells.get_children():
		cell.set_unit(null)
	for child in get_children():
		if child != cells:
			remove_child(child)
	
func on_rotation_complete(cell_index):
	var unit = cells.get_child(cell_index).get_unit()
	if unit == null:
		return
	unit.get_node("Visual/Sprite").set_modulate(Color("8b8b8b"))

func remove_unit(cell_idx):
	var unit = cells.get_child(cell_idx).get_unit()
	if unit:
		unit.remove(false)