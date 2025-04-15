extends Resource
class_name Ability
# This will only be used by the enemy

## The[@param Node] is the caller
@warning_ignore("unused_parameter")
func trigger(node: Node, target: Character) -> void:
	pass