@tool
extends SlotMachine

@export var column_sprite: Texture2D

@export_range(1, 5, 1) var columns: int = 3: set = set_columns;

@export var roll_duration: float = 5.0

var mouse_in_lever: bool = false

func _ready():
	generate_columns(columns)

func set_columns(val: int) -> void:
	if !column_sprite:
		printerr("column_sprite is empty")
		return

	columns = val

	generate_columns(columns)
	

func create_column_sprite() -> Sprite2D:
	var new_sprite: Sprite2D = Sprite2D.new()
	new_sprite.texture = column_sprite
	new_sprite.centered = false
	return new_sprite


func generate_columns(amt: int) -> void:
	for child: Node2D in %Columns.get_children():
		child.queue_free()
	
	for i in amt:
		var column: Sprite2D = create_column_sprite()
		var size_x: float = (column_sprite.get_size().x - 2) * i
		
		column.position.x += size_x
		%Lever.position.x = (size_x + (column_sprite.get_size().x))
		%Columns.add_child(column)


func _input(event: InputEvent):
	if event.is_action_released(&"MB1"):
		if mouse_in_lever:
			if %Lever.is_playing(): return
			
			%Lever.play("rolling")
			await get_tree().create_timer(roll_duration).timeout
			%Lever.play("default")


func _on_area_2d_mouse_entered() -> void:
	mouse_in_lever = true;
	print(mouse_in_lever)


func _on_area_2d_mouse_exited() -> void:
	mouse_in_lever = false;
	print(mouse_in_lever)
