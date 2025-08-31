extends AnimatedSprite2D

@onready var Particles = $GPUParticles2D
var Animations: Array = ["Smoke1", "Smoke2"]

func _ready() -> void:
	var rand_anim = randi_range(0, Animations.size() - 1)
	play(Animations[rand_anim])
	Particles.emitting = true
	
func get_cell_texture(tilemap, coord:Vector2i) -> Texture:
	var source_id = tilemap.get_cell_source_id(coord)
	var source:TileSetAtlasSource = tilemap.tile_set.get_source(source_id) as TileSetAtlasSource
	var altas_coord = tilemap.get_cell_atlas_coords(coord)
	var rect := source.get_tile_texture_region(altas_coord)
	var image:Image = source.texture.get_image()
	var tile_image := image.get_region(rect)
	Particles.texture = ImageTexture.create_from_image(tile_image)
	return 

func _on_gpu_particles_2d_finished() -> void:
	queue_free()
