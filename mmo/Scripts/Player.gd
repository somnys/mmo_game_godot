extends Area2D

@onready var anim = $AnimationPlayer
@onready var movement_timer = $Timer
@onready var camera = $Camera2D
@onready var anim_tree = $AnimationTree
@onready var ray = $RayCast2D
@onready var pathfinder = get_parent().get_node("Pathfinder")


var tile_size = 32
var moving = false
var inputs = {"right" : Vector2.RIGHT, "left":Vector2.LEFT, "up":Vector2.UP, "down":Vector2.DOWN}
var input_dir = Vector2.ZERO
var move_queue = []
var current_move
var mouse_pos 

#this will be the container for player account loaded from db
var player_data = {}

#temp stat variables for battle testing
var dmg = 1
var hp = 100
var sa = 11


enum States {FREE, BATTLE, DEAD}

func _ready():
	pass

func input_action(dir):
	if ray.is_colliding():
			anim_tree.set("parameters/Idle/blend_position", inputs[dir])
	move(dir)
	clear_queue()
	

func key_input():
	#movement
	if Input.is_action_pressed("left"):
		input_action("left")
	elif Input.is_action_pressed("right"):
		input_action("right")
	elif Input.is_action_pressed("up"):
		input_action("up")
	elif Input.is_action_pressed("down"):
		input_action("down")
	else:
		input_dir = Vector2.ZERO

func _process(delta):
	mouse_pos = get_parent().tilemap.local_to_map(get_global_mouse_position())
	if Input.is_action_just_pressed("click"):
			#movement
			move_queue = pathfinder.find_path(get_parent().tile_pos, mouse_pos)
			next_move()

	if moving:
		return
	else:
		key_input()
		if current_move:
			if current_move == Vector2i.UP:
				move("up")
			elif current_move == Vector2i.DOWN:
				move("down")
			elif current_move == Vector2i.LEFT:
				move("left")
			elif current_move == Vector2i.RIGHT:
				move("right")
			next_move()
	update_animation()
	
func update_animation():
	if input_dir.normalized() == Vector2.ZERO and !moving:
		anim_tree.set("parameters/conditions/idle", true)
		anim_tree.set("parameters/conditions/is_walking", false)
	else:
		anim_tree.set("parameters/conditions/idle", false)
		anim_tree.set("parameters/conditions/is_walking", true)
	if input_dir.normalized() != Vector2.ZERO:
		anim_tree.set("parameters/Idle/blend_position", input_dir.normalized())
		anim_tree.set("parameters/Walk/blend_position", input_dir.normalized())

func next_move():
	if len(move_queue) == 0:
		current_move = null
		return
	var next = move_queue.pop_front()
	current_move = next
	
func clear_queue():
	current_move = null
	move_queue = []

func move(dir):
	ray.target_position = inputs[dir] * tile_size
	ray.force_raycast_update()
	if !ray.is_colliding():
		input_dir = inputs[dir]
		var tween = create_tween()
		tween.tween_property(self, "global_position",
			position + inputs[dir] * tile_size, 0.2).set_trans(Tween.TRANS_LINEAR)
		moving = true
		await tween.finished
		moving = false
	else:
		input_dir = Vector2.ZERO
		
