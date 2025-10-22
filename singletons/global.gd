extends Node

var ROTATION_AXIS:Vector2 = Vector2.ZERO

var Player_1: PlayerResource = load("res://resources/players/Player1.tres")
var Player_2: PlayerResource = load("res://resources/players/Player2.tres")
var Player_3: PlayerResource = load("res://resources/players/Player3.tres")
var Player_4: PlayerResource = load("res://resources/players/Player4.tres")


var PLAYERS:Array[PlayerResource] = [
	Player_1,
	Player_2,
	Player_3,
	Player_4
]
