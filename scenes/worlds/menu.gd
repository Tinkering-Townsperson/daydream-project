extends Control

var current_index: int = 0

const JUMP_VELOCITY = -1400

@export var play: Callable
@export var select_level: Callable

var inventory: Inventory
var y_positions = [300.0, 460.0]
var actions: Array
var call_action = false

func _ready() -> void:
	#main_theme.play()
	
	inventory = preload("res://Inventory.gd").new()
	actions = [
		play, select_level
	]


func _process(_delta: float) -> void:
	pass


func _on_play_button_pressed() -> void:
	play.call()
