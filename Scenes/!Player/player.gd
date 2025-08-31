extends CharacterBody2D

signal digging

@export var digging_power: int = 1

@onready var sprite = $PlayerSprite
@onready var camera = $Camera2D

var speed = 80.0
var jump_velocity = -300.0

var limits = [0, 0, 0, 0] #~

const COYOTE_TIME: float = 0.15
var coyote_timer: float = COYOTE_TIME
var can_jump: bool = true

var digging_range: float = 36.0
var is_digging: bool = false

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	var mouse_direction = global_position.direction_to(get_global_mouse_position())
	var mouse_angle = rad_to_deg(Vector2.RIGHT.angle_to(mouse_direction)) 
	var tween = create_tween()
	
	if not is_on_floor():
		velocity += get_gravity() * delta 
		sprite.anim_idle()
		coyote_timer -= delta
	else:
		coyote_timer = COYOTE_TIME
		can_jump = true
	
	if Input.is_action_just_pressed("ui_accept"):
		if coyote_timer > 0 and can_jump == true:
			_jump(tween)
	
	if mouse_angle >= -90 and mouse_angle <= 90:
		sprite.flip_sprite(mouse_direction.x)
		sprite.head.rotation_degrees = mouse_angle
	else:
		sprite.flip_sprite(mouse_direction.x)
		sprite.head.rotation_degrees = mouse_angle + 180
	
	if direction:
		if is_on_floor():
			tween.tween_property(sprite, "rotation", direction / 6, 0.3)
		else:
			tween.tween_property(sprite, "rotation", -direction / 3, 0.6)
		velocity.x = direction * speed
		sprite.anim_walk()
	else:
		tween.tween_property(sprite, "rotation", 0, 0.2)
		sprite.anim_idle()
		velocity.x = move_toward(velocity.x, 0, speed)
		
	if is_digging:
		var dig_position = position + Vector2(0, -16)
		if dig_position.distance_to(get_global_mouse_position()) < digging_range:
			digging.emit(get_global_mouse_position(), digging_power)
		is_digging = false
		
	# Границы (потом их не будет)
	position.x = clamp(position.x, limits[0], limits[1])
	if position.y > limits[3] * 2:
		velocity.y = 0
		position.y = limits[2]
		
	move_and_slide()

func _jump(tween):
	tween.tween_property(sprite, "scale", Vector2(1.2, 0.8), 0.1)
	tween.tween_property(sprite, "scale", Vector2(1, 1), 0.1)
	velocity.y = jump_velocity
	can_jump = false

func _input(_event):
	const MinZoom: float = 1.5
	const MaxZoom: float = 4.0
	
	if Input.is_action_just_pressed("zoom_in"):
		var zoom_val = camera.zoom.x
		if camera.zoom.x < MaxZoom:
			zoom_val += 0.1
		camera.zoom = Vector2(zoom_val,zoom_val)
	elif Input.is_action_just_pressed("zoom_out"):
		var zoom_val = camera.zoom.x
		if camera.zoom.x > MinZoom:
			zoom_val -= 0.1
		camera.zoom = Vector2(zoom_val,zoom_val)
	
	if Input.is_action_just_pressed("LMB"):
		is_digging = true
