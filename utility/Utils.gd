extends Node

func get_inactive_players() -> Array[PlayerResource]:
	return Global.PLAYERS.filter(func (player): return !player.active)


func get_active_players() -> Array[PlayerResource]:
	return Global.PLAYERS.filter(func (player): return player.active)
