extends Node

var path = "user://"

func _ready() -> void:
	var persist_dir := DirAccess.open(path)
	if persist_dir:
		if persist_dir.dir_exists("saves"):
			pass
		else:
			persist_dir.make_dir("saves")
			var dir = DirAccess.open("user://saves")
			dir.make_dir("players")
			dir.make_dir("worlds")
	else:
		print("Не загрузил")
