extends Sprite2D
const ACTIVE_COLOR = Color(0.996, 0.173, 0.333)
const INACTIVE_COLOR = Color(1.0, 1.0, 1.0)
const LIKE_ANIMATION_DURATION: float = 0.45
const UNLIKE_ANIMATION_DURATION: float = 0.25
const LIKE_SCALE_MULTIPLIER: float = 1.2
const UNLIKE_SCALE_MULTIPLIER: float = 1.1
const BOUNCE_HEIGHT: float = -25.0
const OVERSHOOT_AMOUNT: float = 8.0  # How much it bounces past original position

var is_liked: bool = false
var animation_progress: float = 0.0
var is_animating: bool = false
var original_position: Vector2
var original_scale: Vector2

func _ready() -> void:
	original_position = position
	original_scale = scale
	modulate = Color.WHITE

func _on_button_button_down() -> void:
	is_liked = !is_liked
	is_animating = true
	animation_progress = 0.0

func _process(delta: float) -> void:
	# Determine animation duration based on like state
	var anim_duration: float = LIKE_ANIMATION_DURATION if is_liked else UNLIKE_ANIMATION_DURATION
	
	# Update animation progress
	if is_animating:
		animation_progress += delta / anim_duration
		
		if animation_progress >= 1.0:
			animation_progress = 1.0
			is_animating = false
			# Reset to original state after animation
			scale = original_scale
			position = original_position
	
	# Smooth color transition - faster for liking
	var target_color: Color = ACTIVE_COLOR if is_liked else INACTIVE_COLOR
	var color_speed: float = 15.0 if is_liked else 8.0
	modulate = modulate.lerp(target_color, delta * color_speed)
	
	# Different animations for like vs unlike
	if is_animating:
		if is_liked:
			# LIKE ANIMATION: Bounce up, drop fast, overshoot and settle
			var t: float = animation_progress
			
			if t < 0.4:
				# Going up - ease out (40% of animation)
				var up_t: float = t / 0.4
				up_t = ease(up_t, -2.0)
				position.y = original_position.y + BOUNCE_HEIGHT * up_t
				
				# Scale up while going up
				var scale_mult: float = 1.0 + (LIKE_SCALE_MULTIPLIER - 1.0) * up_t
				scale = original_scale * scale_mult
			elif t < 0.7:
				# Falling down fast - ease in hard (30% of animation)
				var down_t: float = (t - 0.4) / 0.3
				down_t = ease(down_t, 3.0)  # Stronger ease in = faster fall
				position.y = original_position.y + BOUNCE_HEIGHT * (1.0 - down_t) + OVERSHOOT_AMOUNT * down_t
				
				# Scale back down to normal
				var scale_mult: float = LIKE_SCALE_MULTIPLIER - (LIKE_SCALE_MULTIPLIER - 1.0) * down_t
				scale = original_scale * scale_mult
			else:
				# Quick bounce back up from overshoot (30% of animation)
				var bounce_t: float = (t - 0.7) / 0.3
				bounce_t = ease(bounce_t, -2.0)  # Ease out
				position.y = original_position.y + OVERSHOOT_AMOUNT * (1.0 - bounce_t)
				
				# Keep scale at normal
				scale = original_scale
		else:
			# UNLIKE ANIMATION: Quick pulse in place
			var t: float = animation_progress
			
			# Simple pulse: grow then shrink
			var pulse_t: float = sin(t * PI)
			var current_scale_mult: float = 1.0 + (UNLIKE_SCALE_MULTIPLIER - 1.0) * pulse_t
			scale = original_scale * current_scale_mult
			
			# Stay in place (no position change)
			position = original_position
