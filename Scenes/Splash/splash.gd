extends Node2D

var skip: bool = false

func _ready() -> void:
	$CanvasLayer/Button.grab_focus()
	
func _on_timer_timeout() -> void:
	TransitionScreen._transition()
	await TransitionScreen.on_transition_finished
	if !skip:
		skip = true
		get_tree().change_scene_to_file("res://Scenes/Menu/main.tscn")

func _on_button_pressed() -> void:
		_on_timer_timeout()
