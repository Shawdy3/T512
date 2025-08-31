extends Control

@onready var list = $VBoxContainer/ScrollContainer/VBoxContainer
@onready var path: String = "user://saves/players/"

var Main: Node2D

func _ready() -> void:
	await get_tree().process_frame
	update_list()

func create_character_list():
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "" and file_name.get_extension() == "json":
			var save_path = path + file_name
			var save_file = FileAccess.open(save_path, FileAccess.READ)
			var json = save_file.get_as_text()
			var PlayerData = JSON.parse_string(json)
			save_file.close()
			create_character_panel(PlayerData, path + file_name)
			
			file_name = dir.get_next()
	else:
		print("Не нашел папку")

func create_character_panel(PlayerData, savepath):
	var character_panel = preload("res://Scenes/Menu/Chooser/character_panel.tscn").instantiate()
	var style_texture = load(PlayerData["_Style_texture"])
	
	list.add_child(character_panel)
	character_panel.Chooser = self
	
	character_panel.name_label.text = PlayerData["!Name"]
	character_panel.fav_button.button_pressed = PlayerData["!Fav"]
	character_panel.Fav = PlayerData["!Fav"]
	
	character_panel.player_sprite.style1.texture = style_texture
	character_panel.player_sprite.style2.texture = style_texture
	character_panel.player_sprite.hair.frame = PlayerData["_Hair_id"]
	character_panel.player_sprite.eyes.frame = PlayerData["_Eyes_id"]
	
	character_panel.player_sprite.base.self_modulate = Color.hex(PlayerData["BaseColor"])
	character_panel.player_sprite.head.self_modulate = Color.hex(PlayerData["BaseColor"])
	character_panel.player_sprite.eyes.self_modulate = Color.hex(PlayerData["EyesColor"])
	character_panel.player_sprite.hair.self_modulate = Color.hex(PlayerData["HairColor"])
	character_panel.player_sprite.style1.self_modulate = Color.hex(PlayerData["Style1Color"])
	character_panel.player_sprite.style2.self_modulate = Color.hex(PlayerData["Style2Color"])
	
	character_panel.save_path = savepath
	
func update_list():
	for i in list.get_children():
		i.queue_free()
	create_character_list()
	
	for i in list.get_children():
		if i.Fav == true:
			list.move_child(i, 0)
	
func delete_file(savepath):
	var dir = DirAccess.open(path)
	if dir.file_exists(savepath):
		var delete = dir.remove(savepath)
		if delete == OK:
			print("удалил: " + savepath)
		else:
			print("не удалось удалить файл: " + savepath)
	update_list()
	
func set_favorite(save_path):
	var file = FileAccess.open(save_path, FileAccess.READ)
	var json = file.get_as_text()
	var PlayerData = JSON.parse_string(json)
	file = FileAccess.open(save_path, FileAccess.WRITE)
	PlayerData["!Fav"] = !PlayerData["!Fav"]
	json = JSON.stringify(PlayerData)
	file.store_string(json)
	file.close()
	
	update_list()


func _on_back_button_pressed() -> void:
	Main.to_main()
	queue_free()

func _on_create_button_pressed() -> void:
	Main.to_creator()
	queue_free()
	
