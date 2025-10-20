extends Node

func get_inactive_players() -> Array[PlayerResource]:
	return Global.PLAYERS.filter(func (p): return !p.active)


func get_active_players() -> Array[PlayerResource]:
	return Global.PLAYERS.filter(func (p): return p.active)
