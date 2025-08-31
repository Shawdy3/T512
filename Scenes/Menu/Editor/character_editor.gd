extends Control

signal close

@onready var editor_sprite = $Redactor/MainButtons/CharacterPanel/PlayerSprite
@onready var color_picker = $Redactor/ColorPicker
@onready var hair_label = $"Redactor/MainButtons/CustomizationButtons/Hair&Eyes/HairColor/RichTextLabel"
@onready var base_label = $Redactor/MainButtons/CustomizationButtons/SkinColor/RichTextLabel
@onready var eyes_label = $"Redactor/MainButtons/CustomizationButtons/Hair&Eyes/EyeColor/RichTextLabel"
@onready var style1_label = $Redactor/MainButtons/CustomizationButtons/Style/Style1Color/RichTextLabel
@onready var style2_label = $Redactor/MainButtons/CustomizationButtons/Style/Style2Color/RichTextLabel

var has_style: bool

var Style_texture: Texture2D
var Hair_id: int
var Style_id: int
var Eyes_id: int

var HairColor: Color
var BaseColor: Color
var Style1Color: Color
var Style2Color: Color
var EyesColor: Color

var Style_textures: Array[Texture2D] = [
	preload("res://Sprites/Character/Styles/PlayerStyle1.png"),
	preload("res://Sprites/Character/Styles/PlayerStyle2.png"),
	preload("res://Sprites/Character/Styles/PlayerStyle3.png"),
	preload("res://Sprites/Character/Styles/PlayerStyle4.png")]

var Hair_textures: Array[Texture2D] = [
	preload("res://Sprites/Character/Other/Hairs.png")]

var Eyes_textures: Array[Texture2D] = [
	preload("res://Sprites/Character/Other/Eyes.png")]

var EditingColor: String

func _ready() -> void:
	await get_tree().process_frame
	if !has_style:
		_randomize_cosmetics()
		_randomize_colors()
	
# Панель персонажа
func _on_character_panel_mouse_entered() -> void:
	editor_sprite.anim_walk()
func _on_character_panel_mouse_exited() -> void:
	editor_sprite.anim_idle()

# Волосы
func _on_prev_hair_pressed() -> void:
	_change_prev_hair()

func _on_hair_color_focus_entered() -> void:
	EditingColor = "Hair"
	hair_label.text =  "[wave]Волосы"
	color_picker.color = HairColor
func _on_hair_color_focus_exited() -> void:
	hair_label.text =  "Волосы"

func _on_next_hair_pressed() -> void:
	_change_next_hair()

func _change_prev_hair():
	if Hair_id > 0:
		Hair_id -= 1
	else:
		Hair_id = 3
	editor_sprite.Hair_id = Hair_id
	editor_sprite._update_hair()
func _change_next_hair():
	if Hair_id < 3:
		Hair_id += 1
	else:
		Hair_id = 0
	editor_sprite.Hair_id = Hair_id
	editor_sprite._update_hair()

# Глаза
func _on_prev_eyes_pressed() -> void:
	_change_prev_eyes()

func _on_eye_color_focus_entered() -> void:
	EditingColor = "Eyes"
	eyes_label.text =  "[wave]Глаза"
	color_picker.color = EyesColor
func _on_eye_color_focus_exited() -> void:
	eyes_label.text =  "Глаза"

func _on_next_eyes_pressed() -> void:
	_change_next_eyes()

func _change_prev_eyes():
	if Eyes_id > 0:
		Eyes_id -= 1
	else:
		Eyes_id = 3
	editor_sprite.Eyes_id = Eyes_id
	editor_sprite._update_eyes()
func _change_next_eyes():
	if Eyes_id < 3:
		Eyes_id += 1
	else:
		Eyes_id = 0
	editor_sprite.Eyes_id = Eyes_id
	editor_sprite._update_eyes()

# Кожа
func _on_skin_color_focus_entered() -> void:
	EditingColor = "Base"
	base_label.text =  "[wave]Цвет кожи"
	color_picker.color = BaseColor
func _on_skin_color_focus_exited() -> void:
	base_label.text =  "Цвет кожи"

# Стиль
func _on_prev_style_pressed() -> void:
	_change_prev_style()

func _on_style_1_color_focus_entered() -> void:
	EditingColor = "Style1"
	style1_label.text =  "[wave]Одежда 1"
	color_picker.color = Style1Color
func _on_style_1_color_focus_exited() -> void:
	style1_label.text =  "Одежда 1"

func _on_style_2_color_focus_entered() -> void:
	EditingColor = "Style2"
	style2_label.text =  "[wave]Одежда 2"
	color_picker.color = Style2Color
func _on_style_2_color_focus_exited() -> void:
	style2_label.text =  "Одежда 2"

func _on_next_style_pressed() -> void:
	_change_next_style()

func _change_prev_style():
	if Style_id > 0:
		Style_id -= 1
	else:
		Style_id = Style_textures.size()-1
	editor_sprite.style1.texture = Style_textures[Style_id]
	editor_sprite.style2.texture = Style_textures[Style_id]
	Style_texture = Style_textures[Style_id]
func _change_next_style():
	if Style_id < Style_textures.size()-1:
		Style_id += 1
	else:
		Style_id = 0
	editor_sprite.style1.texture = Style_textures[Style_id]
	editor_sprite.style2.texture = Style_textures[Style_id]
	Style_texture = Style_textures[Style_id]

func _on_color_picker_color_changed(color: Color) -> void:
	match EditingColor:
		"Hair":
			var hair_rect = $"Redactor/MainButtons/CustomizationButtons/Hair&Eyes/HairColor"
			HairColor = color_picker.color
			editor_sprite.hair.self_modulate  = HairColor
			hair_rect.modulate = HairColor
		"Base":
			var base_rect = $Redactor/MainButtons/CustomizationButtons/SkinColor
			BaseColor = color_picker.color
			editor_sprite.base.self_modulate = BaseColor
			editor_sprite.head.self_modulate  = BaseColor
			base_rect.modulate = BaseColor
		"Eyes":
			var eyes_rect = $"Redactor/MainButtons/CustomizationButtons/Hair&Eyes/EyeColor"
			EyesColor = color_picker.color
			editor_sprite.eyes.self_modulate = EyesColor
			eyes_rect.modulate = EyesColor
		"Style1":
			var style_rect = $Redactor/MainButtons/CustomizationButtons/Style/Style1Color
			Style1Color = color_picker.color
			editor_sprite.style1.self_modulate = Style1Color
			style_rect.modulate = Style1Color
		"Style2":
			var style_rect = $Redactor/MainButtons/CustomizationButtons/Style/Style2Color
			Style2Color = color_picker.color
			editor_sprite.style2.self_modulate = Style2Color
			style_rect.modulate = Style2Color

func _on_rand_button_pressed() -> void:
	_randomize_colors()
	_randomize_cosmetics()
	
func _randomize_cosmetics():
	Style_id = randi_range(0, Style_textures.size() - 1)
	editor_sprite.style1.texture = Style_textures[Style_id]
	editor_sprite.style2.texture = Style_textures[Style_id]
	Style_texture = Style_textures[Style_id]
	
	Eyes_id = randi_range(0,3)
	editor_sprite.Eyes_id = Eyes_id
	editor_sprite._update_eyes()
	
	Hair_id = randi_range(0,3)
	editor_sprite.Hair_id = Hair_id
	editor_sprite._update_hair()
func _randomize_colors():
	BaseColor = generate_skin_color()
	editor_sprite.base.self_modulate = BaseColor
	editor_sprite.head.self_modulate = BaseColor
	$Redactor/MainButtons/CustomizationButtons/SkinColor.modulate = BaseColor
	EyesColor = generate_random_color()
	editor_sprite.eyes.self_modulate  = EyesColor
	$"Redactor/MainButtons/CustomizationButtons/Hair&Eyes/EyeColor".modulate = EyesColor
	HairColor = generate_random_color()
	editor_sprite.hair.self_modulate  = HairColor
	$"Redactor/MainButtons/CustomizationButtons/Hair&Eyes/HairColor".modulate = HairColor
	Style1Color = generate_random_color()
	editor_sprite.style1.self_modulate  = Style1Color
	$Redactor/MainButtons/CustomizationButtons/Style/Style1Color.modulate = Style1Color
	Style2Color = generate_random_color()
	editor_sprite.style2.self_modulate  = Style2Color
	$Redactor/MainButtons/CustomizationButtons/Style/Style2Color.modulate = Style2Color

func generate_skin_color() -> Color:
	return Color.from_hsv(
		randf_range(0.05,0.13),
		randf_range(0.3,0.5),
		randf_range(0.8,1.0)
	)
func generate_random_color() -> Color:
	return Color.from_hsv(
		randf(),
		randf(),
		randf_range(0.2, 1.0)
	)

func _on_back_button_pressed() -> void:
	close.emit()
	if get_parent().name == "character_creator":
		get_parent().Main.to_main()
		get_parent().queue_free()
	queue_free()
