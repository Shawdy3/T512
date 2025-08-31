extends Sprite2D
class_name Breakable

signal broken
signal mouse_on_me
signal mouse_off_me
signal expired

@onready var anim = $AnimationPlayer
@onready var timer = $Timer

const EXPIRED_TIME = 5.0
var health: int

func _ready() -> void:
	_anim()

func get_cell_texture(tilemap, coord:Vector2i) -> Texture:
	var source_id = tilemap.get_cell_source_id(coord)
	var source:TileSetAtlasSource = tilemap.tile_set.get_source(source_id) as TileSetAtlasSource
	var altas_coord = tilemap.get_cell_atlas_coords(coord)
	var rect := source.get_tile_texture_region(altas_coord)
	var image:Image = source.texture.get_image()
	var tile_image := image.get_region(rect)
	texture = ImageTexture.create_from_image(tile_image)
	return 
	
func take_damage(amt: int) -> void:
	timer.start(EXPIRED_TIME)
	if health <= amt:
		broken.emit(self)
		queue_free()
	else:
		health -= amt
		_anim()

func _anim():
	anim.stop()
	anim.play("Hit")
	await anim.animation_finished
	texture = null

func _on_area_2d_mouse_entered() -> void:
	mouse_on_me.emit(self)
func _on_area_2d_mouse_exited() -> void:
	mouse_off_me.emit(self)

func _on_timer_timeout() -> void:
	expired.emit(self)
	$Area2D.process_mode = Node.PROCESS_MODE_DISABLED
	call_deferred("queue_free")
