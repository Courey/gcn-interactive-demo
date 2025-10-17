extends Node

var ROTATION_AXIS:Vector2 = Vector2.ZERO

var Player_1: PlayerResource = load("res://resources/Player1.tres")
var Player_2: PlayerResource = load("res://resources/Player2.tres")
var Player_3: PlayerResource = load("res://resources/Player3.tres")
var Player_4: PlayerResource = load("res://resources/Player4.tres")


var PLAYERS:Array[PlayerResource] = [
	Player_1,
	Player_2,
	Player_3,
	Player_4
]
