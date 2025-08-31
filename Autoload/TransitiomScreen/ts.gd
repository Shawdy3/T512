extends Node2D

signal on_transition_finished
var can_transition: bool = true
@onready var rect = $CanvasLayer/ColorRect

func _ready() -> void:
	_fade_out()
	$AnimationPlayer.animation_finished.connect(_on_animation_finished)
	
func _on_animation_finished(anim_name):
	if anim_name == "FadeIn":
		on_transition_finished.emit()
		$AnimationPlayer.play("FadeOut")
	elif anim_name == "FadeOut":
		rect.visible = false
		can_transition = true

func _transition():
	rect.visible = true
	can_transition = false
	$AnimationPlayer.play("FadeIn")

func _fade_out():
	$AnimationPlayer.play("FadeOut")
