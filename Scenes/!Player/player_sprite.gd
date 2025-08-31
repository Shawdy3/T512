extends Node2D

@onready var base = $Base
@onready var style1 = $Base/Style1
@onready var style2 = $Base/Style2
@onready var head = $Head
@onready var hair = $Head/Hair
@onready var eyes = $Head/Eyes

@onready var Animation_player = $AnimationPlayer

var Hair_id: int 
var Eyes_id: int

func flip_sprite(dir):
	if dir < 0:
		base.flip_h = true
		head.flip_h = true
		style1.flip_h = true
		style2.flip_h = true
		hair.flip_h = true
		eyes.flip_h = true
	elif dir > 0:
		base.flip_h = false
		head.flip_h = false
		style1.flip_h = false
		style2.flip_h = false
		hair.flip_h = false
		eyes.flip_h = false

func _update_hair():
	hair.frame = Hair_id
func _update_eyes():
	eyes.frame = Eyes_id

func anim_walk():
	Animation_player.play("walk")
func anim_idle():
	Animation_player.play("Idle")
