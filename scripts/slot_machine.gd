extends SlotMachine
@export var column_scene: PackedScene
@export_group("Nodes")
@export var columns_node: Node2D
@export var lever_node: AnimatedSprite2D

@export_range(1, 5, 1) var columns: int = 3: set = set_columns;

@export var roll_duration: float = 5.0

@export_group("Slots")
@export var inventory: Array[SlotColumnData] = []

var mouse_in_lever: bool = false

func _ready():
	generate_columns(columns)


func _input(event: InputEvent):
	if event.is_action_released(&"MB1"):
		if mouse_in_lever:
			if lever_node.is_playing(): return

			lever_node.play("rolling")
			if columns_node:
				for child: Node2D in columns_node.get_children():
					child.start_spinning()

			await get_tree().create_timer(roll_duration).timeout

			lever_node.play("default")
			if columns_node:
				for child: Node2D in columns_node.get_children():
					child.stop_spinning()


func set_columns(val: int) -> void:
	if !column_scene:
		printerr("column_scene is empty")
		return

	columns = val

	generate_columns(columns)
	

func generate_columns(amt: int) -> void:
	if !columns_node || !lever_node:
		printerr("columns_node or lever_node is not set")
		return

	if inventory.size() < amt:
		printerr("inventory has less data than the current number of columns")
	
	for child: Node2D in columns_node.get_children():
		child.queue_free()
	
	for i in amt:
		var column: Node2D = column_scene.instantiate()
		var size_x: float = (column.get_size().x - 2) * i

		if inventory.size() >= i:
			print("true")
			column.tokens = inventory[i - 1].tokens

		column.position.x += size_x
		lever_node.position.x = (size_x + (column.get_size().x))
		columns_node.add_child(column)

func _on_area_2d_mouse_entered() -> void:
	mouse_in_lever = true;


func _on_area_2d_mouse_exited() -> void:
	mouse_in_lever = false;
