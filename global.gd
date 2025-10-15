extends Node

var ROTATION_AXIS:Vector2 = Vector2.ZERO

var Player_1: Player = Player.new().setup(1, Color("red"))
var Player_2: Player = Player.new().setup(2, Color("blue"))
var Player_3: Player = Player.new().setup(1, Color("green"))
var Player_4: Player = Player.new().setup(1, Color("white"))


var PLAYERS:Array[Player] = [
	Player_1,
	Player_2,
	Player_3,
	Player_4
]
