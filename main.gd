extends Node2D

@onready var level_container = $LevelContainer
@onready var menu_scene: PackedScene = preload("res://scenes/worlds/menu.tscn")
@onready var credits_scene: PackedScene = preload("res://scenes/Credits.tscn")
var inventory = preload("res://Inventory.gd").new()


var current_level = null
var menu: Control
var credits_menu: Control
var paused: bool = false

func _ready():
	# Debugging - print the node path to verify it exists
	print_debug("Node path: ", get_path(), "\nChildren: ", get_children())
	
	# Make sure the level container exists
	if has_node("LevelContainer"):
		print_debug("LevelContainer found")
	else:
		push_error("LevelContainer not found!")
		# Try to create it if missing
		var container = Node.new()
		container.name = "LevelContainer"
		add_child(container)
		level_container = container
	
	load_menu()

func load_menu() -> void:
	if is_level(): remove_levels()
	inventory.fetch_inventory()
	menu = menu_scene.instantiate()
	if menu:
		menu.play = play
		menu.credits = credits
		add_child(menu)

func is_level():
	return level_container.get_child_count() > 0

func remove_levels():
	for child in level_container.get_children():
		child.queue_free()
	
	for child in get_children():
		if "Control" in child.name:
			child.queue_free()
	
	await get_tree().process_frame

func detect_current_level():
	if not is_level():
		return
	
	var current_scene = level_container.get_child(0).get_tree().current_scene
	print("current scene path for this goose goose who cares: " + current_scene.scene_file_path)
	if current_scene:
		var scene_path = current_scene.scene_file_path
		print("Current scene path: ", scene_path)
		
		for i in range(Global.level_paths.size()):
			if Global.level_paths[i] == scene_path:
				Global.current_level_index = i
				print("Detected level index: ", Global.current_level_index)
				return
		
		print("Warning: Current scene is not in the level_paths array")

func play() -> void:
	inventory.fetch_inventory()
	if await load_level(inventory.current_level):
		menu.hide()
	

func credits() -> void:
	if is_level():
		remove_levels()
	
	add_child(credits_scene.instantiate())

func load_level(level_index):
	inventory.fetch_inventory()
	# Clear existing level
	if is_level():
		remove_levels()
		await get_tree().process_frame
	# Load new level
	var level_scene = load(Global.level_paths[level_index])
	if level_scene:
		current_level = level_scene.instantiate()
		await get_tree().process_frame
		level_container.call_deferred("add_child", current_level)
		inventory.current_level = level_index
		print(inventory.current_level)
		inventory.commit_inventory()
		print(inventory.get_inventory())
		return true
	return false

func _process(_delta: float):
	if Input.is_action_just_pressed("pause"):
		load_menu()
