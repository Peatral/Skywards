extends Node2D

var center = Vector2()
var time = 0
var shockParams = Vector3(10, 0.8, 0.1)
var strength = 1
var stayTime = 2 #Keep it short

var valid = false

func _ready():
	$Shockwave.scale = get_viewport_rect().size
	set("rect", Rect2(Vector2(0,0), get_viewport_rect().size))
	set_process(true)
	
	if center.x >= 0 && center.x <= 1 && center.y >= 0 && center.y <= 1:
		center.y = 1-center.y
		$Shockwave.material = $Shockwave.material.duplicate(true)
		$Shockwave.material.set_shader_param("center", center)
		
		valid = true

func _process(delta):
	if valid:
		time += delta
		shockParams.x -= delta*2*1/strength
		shockParams.y -= delta*2*1/strength
		shockParams = Vector3(max(shockParams.x, 0), max(shockParams.y, 0), max(shockParams.z, 0))
		$Shockwave.material.set_shader_param("time", time)
		$Shockwave.material.set_shader_param("shockParams", shockParams)
	
	if strength < 0.1 || time >= stayTime:
		queue_free()
	