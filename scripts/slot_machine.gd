@tool
extends SlotMachine
@export var column_scene: PackedScene
@export_category("Nodes")
@export var columns_node: Node2D
@export var lever_node: AnimatedSprite2D
@export var multiplier_label: Label
@export var sprites_node: Node2D
@export_category("")

@export_range(1, 5, 1) var columns: int = 3: set = set_columns;
@export var roll_duration: float = 5.0

@export_group("Slots")
@export var inventory: Array[SlotColumnData] = []

var mouse_in_lever: bool = false
var winning_tokens: Array[Token] = []: get = get_winning_tokens

var global_multiplier: int = 1: set = set_global_multiplier


func _ready():
	super ()
	generate_columns(columns)
	if Engine.is_editor_hint(): return
	SignalBus.rolled_column.connect(_on_rolled_column)
	SignalBus.rolling_ended.connect(_on_rolled_ended)

func _on_rolled_ended(_winning_tokens: Array[Token]) -> void:
	var grouped_tokens: Dictionary[String, Variant] = group_tokens(_winning_tokens)
	var jackpot: bool = is_jackpot(grouped_tokens)

	if jackpot:
		global_multiplier += 1

	print("Jackpot!" if jackpot else "not jackpot")

	for token: Variant in grouped_tokens.values():
		var duplicated_token: Token = (token["token"] as Token).duplicate()
		# this is conditional
		# duplicated_token.debug_multiplier *= (token["count"] * global_multiplier)
		duplicated_token.debug_multiplier *= (token["count"] * global_multiplier)
		print(duplicated_token.get_display_string())
		print(Enemy.target_enemy.name)
	# await get_tree().create_timer(0.5).timeout
	# roll_column(0)


func _on_rolled_column(column_id: int, winner_token: Token) -> void:
	print("column %s ended rolling, with the winner token being: %s" % [column_id, winner_token.title])
	pass

func _input(event: InputEvent):
	if event.is_action_released(&"MB1"):
		if mouse_in_lever:
			if lever_node.is_playing(): return
			global_multiplier = 1

			lever_node.play("rolling")
			if columns_node:
				for child: Node2D in columns_node.get_children():
					child.start_spinning()

			await get_tree().create_timer(roll_duration).timeout

			for i: int in columns_node.get_children().size():
				stop_spinning_column(i)
				await get_tree().create_timer(0.3).timeout

			lever_node.play("default")
			SignalBus.rolling_ended.emit(winning_tokens)


func update_multiplier_label() -> void:
	if !multiplier_label: return
	multiplier_label.text = "x%s" % global_multiplier
	pass

# { "Attack":{"token":Token,"count":0} }
static func group_tokens(tokens: Array[Token]) -> Dictionary[String, Variant]:
	var dictionary: Dictionary[String, Variant] = {}

	for token in tokens:
		if dictionary.has(token.title):
			dictionary[token.title]["count"] += 1
			continue
		
		dictionary[token.title] = {
			"token": token,
			"count": 1
		}

	return dictionary

func roll_column(column_id) -> void:
	start_spinning_column(column_id)
	await get_tree().create_timer(0.3).timeout
	stop_spinning_column(column_id)
	SignalBus.rolling_ended.emit(winning_tokens)

func start_spinning_column(column_id: int) -> void:
	get_column(column_id).start_spinning()

func stop_spinning_column(column_id: int) -> void:
	var column = get_column(column_id)
	column.stop_spinning()
	column.roll_count += 1
	SignalBus.rolled_column.emit(column_id, column.winner_token)

func is_jackpot(_winning_tokens: Dictionary[String, Variant]) -> bool:
	if _winning_tokens.is_empty(): return false

	for value in _winning_tokens.values():
		if value["count"] == columns:
			return true
	
	return false

func set_global_multiplier(val: int) -> void:
	global_multiplier = val
	update_multiplier_label()

func get_column(column_id: int) -> Node:
	assert(columns_node, "columns_node is null")

	var _columns: Array[Node] = columns_node.get_children()

	assert(_columns.size() >= 0, "columns_node does not have children")
	
	return _columns[clampi(column_id, 0, _columns.size())]

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
			column.tokens = inventory[i - 1].tokens

		column.position.x += size_x
		column.column_id = i
		lever_node.position.x = (size_x + (column.get_size().x))
		sprites_node.position.x = (- (size_x * 0.5))
		columns_node.add_child(column)

func get_winning_tokens() -> Array[Token]:
	if !columns_node: return []

	var tokens: Array[Token] = []

	for column in columns_node.get_children():
		tokens.append(column.winner_token)

	return tokens

func _on_area_2d_mouse_entered() -> void:
	mouse_in_lever = true;

func _on_area_2d_mouse_exited() -> void:
	mouse_in_lever = false;
