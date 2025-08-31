extends Button

var Chooser: Control
var save_path: String
var Fav: bool = false

@onready var name_label = $MarginContainer/HBoxContainer/Text/Name
@onready var play_time_label = $MarginContainer/HBoxContainer/Text/PlayTime
@onready var player_sprite = $MarginContainer/HBoxContainer/PlayerPanel/PlayerSprite

@onready var main_container = $MarginContainer/HBoxContainer
@onready var delete_container = $MarginContainer/DeleteContainer

@onready var fav_button = $MarginContainer/HBoxContainer/VBoxContainer/FavoriteButton

func _ready() -> void:
	_to_main()

#var PlayerData: Dictionary = {
	#"!Name": "",
	#"!Fav": false,
	#"_Style_texture": null,
	#"_Hair_id": 0,
	#"_Eyes_id": 0,
	#"BaseColor": null,
	#"HairColor": null,
	#"EyesColor": null,
	#"Style1Color": null,
	#"Style2Color": null 
	#}

func _on_pressed() -> void:
	if TransitionScreen.can_transition == true:
		TransitionScreen._transition()
		Global.PlayerDataPath = save_path
		await TransitionScreen.on_transition_finished
		get_tree().change_scene_to_file("res://Scenes/!Map/map_1.tscn")

func _on_player_panel_mouse_entered() -> void:
	player_sprite.anim_walk()

func _on_player_panel_mouse_exited() -> void:
	player_sprite.anim_idle()

func _on_delete_button_pressed() -> void:
	_to_delete()
	
func _on_favorite_button_pressed() -> void: 
	Chooser.set_favorite(save_path)


func _on_cancel_pressed() -> void:
	_to_main()
func _on_confirm_pressed() -> void:
	Chooser.delete_file(save_path)

func _to_delete():
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	delete_container.visible = true
	main_container.visible = false
func _to_main():
	mouse_filter = Control.MOUSE_FILTER_STOP
	main_container.visible = true
	delete_container.visible = false
