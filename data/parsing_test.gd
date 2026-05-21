## Test script to parse using tree-sitter and see the abstract syntax tree (AST)
class_name MyClass extends Sprite2D

var property := Vector2(480, -480)
var array_property: Array[Vector2] = []

@export var exported_property: int = 42:
	get:
		return 4
	set(value):
		exported_property = value
var setget_property: float = 3.2:
	get = get_setget_property,
	set = set_setget_property


func _init() -> void:
	pass

func _process(delta: float) -> void:
	position += velocity * delta
	rotation = velocity.angle()


class InnerClass extends RefCounted:
	func _init(arg: int) -> void:
		pass
