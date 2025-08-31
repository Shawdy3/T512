extends VBoxContainer


var Main: Node2D

func _on_play_button_pressed() -> void:
	Main.play(self)

func _on_settings_button_pressed() -> void:
	Main.settings()

func _on_exit_button_pressed() -> void:
	get_tree().quit()
