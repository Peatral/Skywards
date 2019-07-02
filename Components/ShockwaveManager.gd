extends Component

export(PackedScene) var shockwaveScene = preload("res://Components/Shockwave/Shockwave.tscn")

func shockwave(center = Vector2(), strength = 1, shockParams = Vector3(10, .8, .1)):
	var shockwave = shockwaveScene.instance()
	shockwave.center = center
	shockwave.strength = strength
	shockwave.shockParams = shockParams
	get_tree().root.add_child(shockwave)
