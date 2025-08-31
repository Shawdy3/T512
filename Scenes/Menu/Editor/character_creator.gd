extends VBoxContainer

@onready var LineName = $Creator/HBoxContainer/LineEdit
@onready var Editor = $Character_Editor

var Main: Node2D
var SavePath: String = "user://saves/players/"
var PlayerData: Dictionary = {
	"!Name": "",
	"!Fav": false,
	"_Style_texture": "",
	"_Hair_id": 0,
	"_Eyes_id": 0,
	"BaseColor": null,
	"HairColor": null,
	"EyesColor": null,
	"Style1Color": null,
	"Style2Color": null }

func _on_create_character_pressed() -> void:
	if LineName.text == "":
		LineName.placeholder_text = "Введите имя!"
		LineName.modulate = "ff0000"
	else:
		create_character()


func _on_line_edit_text_changed(_new_text: String) -> void:
	LineName.placeholder_text = "Имя персонажа"
	LineName.modulate = "ffffff"

func create_data():
	PlayerData["!Name"] = LineName.text
	PlayerData["_Style_texture"] = "res://Sprites/Character/Styles/PlayerStyle" + str(Editor.Style_id+1) + ".png"
	PlayerData["_Hair_id"] = Editor.Hair_id
	PlayerData["_Eyes_id"] = Editor.Eyes_id
	PlayerData["BaseColor"] = Editor.BaseColor.to_rgba32()
	PlayerData["HairColor"] = Editor.HairColor.to_rgba32()
	PlayerData["EyesColor"] = Editor.EyesColor.to_rgba32()
	PlayerData["Style1Color"] = Editor.Style1Color.to_rgba32()
	PlayerData["Style2Color"] = Editor.Style2Color.to_rgba32()

func create_character():
	create_data()
	var path = SavePath + PlayerData["!Name"]
	
	var dir = DirAccess.open(SavePath)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "" and file_name.get_extension() == "json":
			if SavePath + file_name == path + ".json":
				path = path + "_"
			file_name = dir.get_next()
		path += ".json"
		
	var file = FileAccess.open(path, FileAccess.WRITE)
	var json_string = JSON.stringify(PlayerData)
	file.store_string(json_string)
	file.close()
	
	print("создал: " + path)
	Main.to_chooser()
	queue_free()
