extends Node

var PlayerDataPath: String

func update_player(Player):
	var save_file = FileAccess.open(PlayerDataPath, FileAccess.READ)
	var json = save_file.get_as_text()
	var PlayerData = JSON.parse_string(json)
	
	var style_texture = load(PlayerData["_Style_texture"])
	
	Player.sprite.style1.texture = style_texture
	Player.sprite.style2.texture = style_texture
	Player.sprite.hair.frame = PlayerData["_Hair_id"]
	Player.sprite.eyes.frame = PlayerData["_Eyes_id"]
	
	Player.sprite.base.self_modulate = Color.hex(PlayerData["BaseColor"])
	Player.sprite.head.self_modulate = Color.hex(PlayerData["BaseColor"])
	Player.sprite.eyes.self_modulate = Color.hex(PlayerData["EyesColor"])
	Player.sprite.hair.self_modulate = Color.hex(PlayerData["HairColor"])
	Player.sprite.style1.self_modulate = Color.hex(PlayerData["Style1Color"])
	Player.sprite.style2.self_modulate = Color.hex(PlayerData["Style2Color"])
	save_file.close()
	
