extends Node2D


func _ready():
	get_viewport().connect("size_changed", Callable(self, "_on_resize"))
	_on_resize()

@export var hide_amount_percentage = 1.0;
var moving = false
var up = false

func _process(delta: float) -> void:
	if (moving):
		if (up):
			if (hide_amount_percentage < 1):
				hide_amount_percentage += delta * 10
			else:
				moving = false
				#hide_amount_percentage = 1
		else:
			if (hide_amount_percentage > 0):
				hide_amount_percentage -= delta * 10
			else:
				moving = false
				#hide_amount_percentage = 0
		update_y_pos()

func update_y_pos():
	var viewport_size = get_viewport_rect().size
	$"bg".position.y = (viewport_size.y / 2) + (viewport_size.y / 3) + (hide_amount_percentage * 4/6 * viewport_size.y)
	

func _on_resize():
	var viewport_size = get_viewport_rect().size
	$"bg".position.x = viewport_size.x / 2
	update_y_pos()
	$"bg".scale.x = viewport_size.x
	$"bg".scale.y = viewport_size.y
	$"bg".material.set_shader_parameter("corner_radius", (viewport_size.x * 40) / viewport_size.x)
	$"bg".material.set_shader_parameter("rect_size", Vector2($"bg".scale.x, $"bg".scale.y))
	$"bg".material.set_shader_parameter("use_white", not $"..".dark_mode)
