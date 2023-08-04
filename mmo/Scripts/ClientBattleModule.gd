extends Node

#@onready var player = get_parent()

var battle_queue = []
var max_turns = 120
var max_at

#var player_at = 1/(player.sa + 1)
var player_at = snapped(1.0/12, 0.001)
var npc_at = snapped(1.0/3, 0.001)

var player_at_sum = 0.00
var npc_at_sum = 0.00


var processing_player :bool
var processing_npc: bool

func _ready():
	print(battle_queue)
	init_queue()
	print(battle_queue)

func init_queue():
	max_at = max(player_at, npc_at)
	if max_at == player_at:
		processing_npc = true
	elif max_at == npc_at:
		processing_player = true
	while len(battle_queue) <= max_turns:
		if processing_player:
			player_at_sum += player_at
			print(player_at_sum)
			if player_at_sum < max_at:
				battle_queue.append(0)
			elif player_at_sum == max_at:
				battle_queue.append(0)
				player_at_sum = 0.0
				processing_player = false
				processing_npc = true
			else:
				var remainder = snapped(max_at - player_at_sum, 0.001)
				player_at_sum = remainder
				processing_player = false
				processing_npc = true
			
		elif processing_npc:
			npc_at_sum += npc_at
			if npc_at_sum < max_at:
				
				battle_queue.append(1)
			elif npc_at_sum == max_at:
				battle_queue.append(1)
				npc_at_sum = 0.0
				processing_player = true
				processing_npc = false
			else:
				var remainder = snapped(max_at - npc_at_sum, 0.001)
				npc_at_sum = remainder
				processing_npc = false
				processing_player = true
			
