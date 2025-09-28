extends Node2D

var time_remaining: int = 30
var time_since_last_update: float = 0.0
var gameover: String = ""

var y_win: PackedScene = preload("res://scenes/y_win.tscn")
var d_win: PackedScene = preload("res://scenes/d_win.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if gameover:
		if gameover == "y":
			var screen = y_win.instantiate()
			$"..".add_child(screen)
		elif gameover == "d":
			var screen = d_win.instantiate()
			$"..".add_child(screen)
		queue_free()
		return
	
	time_since_last_update += delta
	
	if time_since_last_update >= 1:
		time_remaining -= 1
		time_since_last_update -= 1
		$Camera2D/Label.text = str(time_remaining)
		$"Chase!".pitch_scale += 0.025
		
	if time_remaining <= 0:
		gameover = "y"
	
