@tool
extends Node2D
class_name Hand

# NOTE: while a lot of the functions seem to overlap with CardPile, it's different
# enough to not use a CardPile

@export var node_to_add_the_children: Node

@export var hand_radius: float = 30.0: set = set_hand_radius
@export var angle_limit: float = 30.0
@export var max_spread: float = 5

var nodes_inside: Array[Node] = []

# signal cards_repositioned
# signal hand_discarded
# signal hand_empty

signal radius_changed(radius: float)

func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	draw_circle(Vector2.ZERO, hand_radius, Color.RED, false, 3)

func add_node(node: Node) -> void:
	# node.state = node.States.IN_HAND
	node.global_position = Vector2.ZERO
	node.position = Vector2.ZERO
	node_to_add_the_children.add_child(node)
	self.nodes_inside.push_back(node)
	reposition_nodes()
	# card_added.emit(node)

func remove_node(id: int) -> Node:
	var current_node: Node = nodes_inside.pop_at(id)

	if current_node == null:
		printerr("Card id of %s does not exist in the hand" % id)
		return

	current_node.hand_id = -1
	node_to_add_the_children.remove_child(current_node)

	reposition_nodes()

	# card_removed.emit(card_in_hand)
	# if nodes_inside.size() <= 0:
	# 	hand_empty.emit()

	return current_node

## This will remove the cards one for one and trigger all the necessary signals
func discard_hand() -> void:
	for i in nodes_inside.size():
		remove_node(0)

	# hand_discarded.emit()


func update_node_transform(node: Node, desired_angle: float) -> void:
	#TODO: get the enemy size
	var target_pos: Vector2 = get_node_position(desired_angle, hand_radius) # - (node.size * 0.5)
	# var target_rot: float = deg_to_rad(desired_angle + 90)

	node.global_position = target_pos
	# node.global_position.y += 15 if node.get_index() % 2 > 0 else 0
	# node.rotation = target_rot

	# node.hand_pos = target_pos
	# node.move_card(node.hand_pos)

	# node.hand_rot = target_rot
	# node.rotate_card(node.hand_rot)
	# card.set_rotation(deg_to_rad(desired_angle + 90))

func set_hand_radius(val: float) -> void:
	hand_radius = val
	radius_changed.emit(hand_radius)
	reposition_nodes()
	queue_redraw()

func reposition_nodes() -> void:
	var card_spread = min(angle_limit / nodes_inside.size(), max_spread)
	var current_angle = - ((card_spread * (nodes_inside.size() - 1)) / 2) - 90

	for i: int in nodes_inside.size():
		var node: Node = nodes_inside[i]
		update_node_transform(node, current_angle)

		# card.scale_card(Vector2.ONE * (1 - (nodes_inside.size() * 0.1)))
		current_angle += card_spread

	# cards_repositioned.emit()


func _on_debugging_changed(_state: bool):
	queue_redraw()


static func get_node_position(deg: float, radius: float) -> Vector2:
	var x: float = radius * cos(deg_to_rad(deg))
	var y: float = radius * sin(deg_to_rad(deg))
	
	return Vector2(int(x), int(y))
