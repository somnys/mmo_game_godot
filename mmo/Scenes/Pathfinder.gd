extends Node

@onready var tilemap = get_parent().get_node("CollisionMap")

var grid

func find_path(from, target):
	var path = grid.get_id_path(from, target)
	var instructions = []
	for i in range(len(path)-1):
		instructions.append(path[i+1] - path[i])
	return instructions

func _ready():
	grid = AStarGrid2D.new()
	grid.cell_size = Vector2i(32,32)
	grid.region = Rect2i(-1, -1, 98, 102)
	grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	grid.update()
	disable_collisions()

func disable_collisions():
	var collisions = tilemap.get_used_cells(0)
	for cell in collisions:
		grid.set_point_solid(cell)
