extends Control

func _ready():
	updatePts(Stats.pts)
	Stats.connect("ptsChanged", self, "updatePts")
	
	get_tree().root.get_node("Map/Players/P_0").connect("knockbackChanged", self, "updateKB1")
	get_tree().root.get_node("Map/Players/P_1").connect("knockbackChanged", self, "updateKB2")

func updatePts(val):
	$PtsLabel.text = String(val)

func updateKB1(val):
	$PlayerUIs/PlayerUI.kb = val

func updateKB2(val):
	$PlayerUIs/PlayerUI2.kb = val