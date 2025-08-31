extends Node2D

@export_category("Параметры мира")
@export var SizeWorld_x: int = 128
@export var SizeWorld_y: int = 128
@export var CaveLevel: int = 10

@export_category("Шум генерации")
@export var Seed: int
@export var RandSeed: bool = true
@export var surface_noise: FastNoiseLite
@export var cave_noise: FastNoiseLite

@onready var BG = $Background
@onready var tilemap = $World/TileMapLayer
@onready var SpawnPoint = $Players

@onready var breakables = $World/Breakables
var breakable: PackedScene = preload("res://Scenes/!Map/Tilemap/breakable.tscn")

var moused_breakable : Breakable
#
#var mouse_click: bool = false




var coords: Array
func _ready() -> void:
	if !Seed:
		if RandSeed:
			Seed = randi()
			
	surface_noise.seed = Seed
	cave_noise.seed = Seed
		
	_world_gen()
	_spawn_player()
	
func _spawn_player():
	var player = preload("res://Scenes/!Player/player.tscn").instantiate()
	SpawnPoint.add_child(player)
	Global.update_player(player)
	player.camera.limit_left = (-SizeWorld_x/ 2) * 16
	player.camera.limit_right = (SizeWorld_x/ 2) * 16
	
	player.digging.connect(digging)
	
	# эта шняга тоже временно .с."
	player.limits[0] = (-SizeWorld_x/ 2) * 16
	player.limits[1] = (SizeWorld_x/ 2) * 16
	player.limits[2] = (-SizeWorld_y) * 16
	player.limits[3] = (SizeWorld_y) * 16


# Ломание блоков

func digging(mouse_pos: Vector2, dig: int = 1):
	var tile_pos = tilemap.local_to_map(tilemap.to_local(mouse_pos))
	
	var tile_data = tilemap.get_cell_tile_data(tile_pos)
	if !tile_data: return
	
	_spawn_breaking_vfx(tile_pos, randi_range(1,4))
	
	if moused_breakable:
		moused_breakable.get_cell_texture(tilemap,tile_pos)
		moused_breakable.take_damage(dig)
		return
	
	var tile_durability = tile_data.get_custom_data("Durability")
	if tile_durability < dig:
		tilemap.erase_cell(tile_pos)
		_update_neigbours(tile_pos)
		return
	
	var new_breakable: Breakable = breakable.instantiate()
	new_breakable.health = tile_durability - 1
	new_breakable.position = Vector2(tile_pos * 16) + Vector2(8,8)
	
	new_breakable.mouse_off_me.connect(_on_breakable_mouse_off)
	new_breakable.mouse_on_me.connect(_on_breakable_mouse_on)
	new_breakable.broken.connect(_on_breakable_broken)
	
	new_breakable.get_cell_texture(tilemap, tile_pos)
	breakables.add_child(new_breakable)
	
func _spawn_breaking_vfx(tile_pos, Particles_amount):
	var VFX = preload("res://Scenes/!Map/Tilemap/breakingVFX.tscn").instantiate()
	VFX.position = Vector2(tile_pos * 16) + Vector2(8,8)
	breakables.add_child(VFX)
	VFX.Particles.amount = Particles_amount
	VFX.get_cell_texture(tilemap, tile_pos)
	

func _on_breakable_mouse_on(b: Breakable) -> void:
	moused_breakable = b

func _on_breakable_mouse_off(b: Breakable) -> void:
	if moused_breakable == b:
		moused_breakable = null
	
func _on_breakable_broken(b: Breakable) -> void:
	tilemap.erase_cell(tilemap.local_to_map(b.position))
	_update_neigbours(tilemap.local_to_map(b.position))
	moused_breakable = null

func _on_breakable_expired(b: Breakable) -> void:
	if moused_breakable == b:
		moused_breakable = null


func _update_neigbours(tilepos):
	var neigbors: Array
	var positions: Array = [
		Vector2i(-1, -1),  # LU
		Vector2i(-1, 0),   # L
		Vector2i(-1, 1),   # LD
		Vector2i(0, 1),    # D
		Vector2i(1, 1),    # RD
		Vector2i(1, 0),    # R
		Vector2i(1, -1),   # RU
		Vector2i(0, -1),]  # U
		
	for neigbor in positions:
		neigbors.append(tilepos + neigbor)
	BetterTerrain.update_terrain_cells(tilemap, neigbors)

# Генерация мира .с.
func _surface_gen():
	var center_height: int 
	var dirt_coords: Array
	
	for x in range( -SizeWorld_x/2 , SizeWorld_x/2):
		var ground = abs(surface_noise.get_noise_2d(x, 0) * 40)
		
		for y in range(ground, SizeWorld_y):
			var _noise_val = surface_noise.get_noise_2d(x, y)
			
			if y < ground + randi_range(5, CaveLevel + 5):
				BetterTerrain.set_cell(tilemap, Vector2i(x,y), 0) # Dirt
				dirt_coords.append(Vector2i(x,y))
			else:
				BetterTerrain.set_cell(tilemap, Vector2i(x,y), 2) # Stone
			
			coords.append(Vector2i(x,y))
			
		for y in range(ground, SizeWorld_y): # находим высоту на которой спавнить игрока
			if x == 0:
				center_height = y
				break
	SpawnPoint.global_position = Vector2i(0, (center_height * 16) - 16 )
	_grass_gen(dirt_coords)

func _grass_gen(dirt_coords):
	var positions: Array = [
		Vector2i(-1, -1),  # LU
		Vector2i(-1, 0),   # L
		Vector2i(-1, 1),   # LD
		Vector2i(0, 1),    # D
		Vector2i(1, 1),    # RD
		Vector2i(1, 0),    # R
		Vector2i(1, -1),   # RU
		Vector2i(0, -1),]  # U
	for dirt_block in dirt_coords:
		for pos in positions:
			var neigbor_pos = dirt_block + pos
			if BetterTerrain.get_cell(tilemap, neigbor_pos) == -1:
				BetterTerrain.replace_cell(tilemap, dirt_block, 1)
				break

func _cave_gen():
	for x in range(-SizeWorld_x/2 , SizeWorld_x/2):
		for y in range(randi_range(CaveLevel, CaveLevel+2), SizeWorld_y):
			var cave_value = cave_noise.get_noise_2d(x * 0.5, y * 0.5)
			if cave_value < -0.05:
				tilemap.erase_cell(Vector2i(x,y))

func _world_gen():
	_surface_gen()
	_cave_gen()
	BetterTerrain.update_terrain_cells(tilemap, coords)
	
	print("seed : ", Seed)

func _input(_event):
	if Input.is_action_just_pressed("ui_cancel"):
		if TransitionScreen.can_transition == true:
			TransitionScreen._transition()
			await TransitionScreen.on_transition_finished
			get_tree().change_scene_to_file("res://Scenes/Menu/main.tscn")
