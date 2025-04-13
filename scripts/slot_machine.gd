@tool
extends SlotMachine

@export var column_scene: PackedScene

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
			if %Lever.is_playing(): return
			
			%Lever.play("rolling")
			await get_tree().create_timer(roll_duration).timeout
			%Lever.play("default")


func set_columns(val: int) -> void:
	if !column_scene:
		printerr("column_scene is empty")
		return

	columns = val

	generate_columns(columns)
	

func generate_columns(amt: int) -> void:
	if inventory.size() < amt:
		printerr("inventory has less data than the current number of columns")
	
	for child: Node2D in %Columns.get_children():
		child.queue_free()
	
	for i in amt:
		var column: Node2D = column_scene.instantiate()
		var size_x: float = (column.get_size().x - 2) * i
		
		if inventory.size() >= i - 1:
			column.tokens = inventory[i - 1].tokens

		column.position.x += size_x
		%Lever.position.x = (size_x + (column.get_size().x))
		%Columns.add_child(column)

func _on_area_2d_mouse_entered() -> void:
	mouse_in_lever = true;
	print(mouse_in_lever)


func _on_area_2d_mouse_exited() -> void:
	mouse_in_lever = false;
	print(mouse_in_lever)
