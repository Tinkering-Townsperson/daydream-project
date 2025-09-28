extends Control

const VELOCITY = 7.5

@export var play: Callable
@export var credits: Callable

var inventory: Inventory
var actions: Array

@onready var twins = $CharacterBody2D
var current_velocity = VELOCITY


func _ready() -> void:
	#main_theme.play()
	
	inventory = preload("res://Inventory.gd").new()


func _process(_delta: float) -> void:
	twins.position.x += current_velocity
	
	if twins.position.x >= 1552:
		current_velocity = -VELOCITY
		twins.scale = Vector2(-1, 1)
	elif twins.position.x <= -460:
		current_velocity = VELOCITY
		twins.scale = Vector2(1, 1)


func _on_play_button_pressed() -> void:
	play.call()


func _on_credits_pressed() -> void:
	credits.call()
