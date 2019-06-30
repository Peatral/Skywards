extends Node

var pts = 0 setget setPts
signal ptsChanged

var gameRunning = false setget setGameRunning

const uiScene = preload("res://scenes/UI.tscn")


func setPts(val):
	pts = val
	emit_signal("ptsChanged", pts)

func setGameRunning(val):
	gameRunning = val
	
	if gameRunning:
		$Timer.start()
		self.pts = 0
		
		var ui = uiScene.instance()
		add_child(ui)
		
	else:
		if has_node("UI"):
			get_node("UI").queue_free()
		
		$Timer.stop()

func on_Timer_timeout():
	self.pts = min(pts +1, 100)
