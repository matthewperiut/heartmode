extends Node2D

func _ready():
	get_viewport().connect("size_changed", Callable(self, "_on_resize"))
	_on_resize()

func _on_resize():
	var viewport_size = get_viewport_rect().size
	position.x = viewport_size.x
	position.y = viewport_size.y / 2
	
	var viewport_comp = viewport_size.x if viewport_size.x < viewport_size.y else viewport_size.y
	scale.x = viewport_comp / 800
	scale.y = scale.x

func set_like_ct(ct):
	$"Like/Count".text = "[center]" + str(ct) + "[/center]"
	pass
	
	
func set_comment_ct(ct):
	$"Comment/Count".text = "[center]" + str(ct) + "[/center]"
	pass
	
	
func set_favorite_ct(ct):
	$"Favorite/Count".text = "[center]" + str(ct) + "[/center]"
	pass

var likes = 0;
var comments = 0;
var favorites = 0;



func _on_button_pressed() -> void:
	set_like_ct(likes + 1 if $"Like/Button".button_pressed else 0)
	set_favorite_ct(favorites + 1 if $"Favorite/Button".button_pressed else 0)
	pass # Replace with function body.
