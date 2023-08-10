extends Control

@onready var stats_window = $Character/Stats
@onready var expand_button = $Character/ExpandStatsButton
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_expand_stats_button_pressed():
	if stats_window.visible:
		stats_window.visible = false
		expand_button.text = "Expand stats"
	else:
		stats_window.visible = true
		expand_button.text = "Collapse stats"


func _on_close_button_pressed():
	visible = false
