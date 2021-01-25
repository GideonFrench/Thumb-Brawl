extends Node

var target : Vector2
var player : KinematicBody2D
var attacker : bool = false
var score : int = 0
var end : bool = false
var health : int = 0
var wiper
var endscreen

func _ready():
	health = 3
	score = 0

func _process(delta):
	if score == 10:
		end = true
	if health < 1:
		health = 3
		score = 0
		wiper.wipe()
	if end == true:
		wiper.wipe_end()
