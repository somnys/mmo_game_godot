extends Node2D

@onready var player_pos = $CanvasLayer/PlayerPos
@onready var tilemap = $CollisionMap
@onready var player = $Player
var tile_pos = Vector2.ZERO

func _process(delta):
	tile_pos = tilemap.local_to_map(player.position)
	player_pos.text = str(tile_pos)
