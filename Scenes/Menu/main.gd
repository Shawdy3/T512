extends Node2D

@onready var BG = $ui/SurfaceBG
@onready var Animation_Player = $AnimationPlayer
@onready var Menus = $ui/Margin/Container/Menus

func _ready() -> void:
	
	Animation_Player.play("LogoRotate")
	to_main()

func _process(delta: float) -> void:
	BG.BG.scroll_offset.x += delta * 100

func to_main():
	var MenuScene = preload("res://Scenes/Menu/MainMenu/main_menu.tscn").instantiate()
	Menus.add_child(MenuScene)
	MenuScene.Main = self
	
func play(MainScene):
	var dir = DirAccess.open("user://saves/players/")
	dir.list_dir_begin()
	var file = dir.get_next()
	if file != "" and file.get_extension() == "json":
		to_chooser()
	else:
		to_creator()
	MainScene.queue_free()

func settings():
	print("Settings")

func to_creator():
	var CreatorScene = preload("res://Scenes/Menu/Editor/character_creator.tscn").instantiate()
	Menus.add_child(CreatorScene)
	CreatorScene.Main = self

func to_chooser():
	var ChooserScene = preload("res://Scenes/Menu/Chooser/character_chooser.tscn").instantiate()
	Menus.add_child(ChooserScene)
	ChooserScene.Main = self
