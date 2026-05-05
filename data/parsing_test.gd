## Test script to parse using tree-sitter and see the abstract syntax tree (AST)
class_name MyClass extends Sprite2D

var property := Vector2(480, -480)

func _init() -> void:
	pass

func _process(delta: float) -> void:
	position += velocity * delta
	rotation = velocity.angle()


class InnerClass extends RefCounted:
	func _init(arg: int) -> void:
		pass
