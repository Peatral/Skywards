extends Node2D

func _ready():
	for sp in $SpawnPoints.get_children():
		var p = load("res://Components/Characters/OG.tscn").instance()
		var id = int(sp.name.replace("P_", ""))
		p.name = "P_" + String(id)
		p.playerID = id
		p.position = sp.position
		$Players.add_child(p)
	
	Stats.gameRunning = true
