extends CharacterBase

func onDied():
	var strength = 1
	var center = (p.get_global_transform_with_canvas().origin+Vector2(0, -40))/p.get_viewport_rect().size
	p.get_node("ShockwaveManager").shockwave(center, 1)
	p.get_parent().get_parent().get_node("Camera2D/ScreenShake").start(.2, 15, 10*strength)
	
	stateMachine.get("parameters/playback").start("Spawn")

func _process(delta):
	
	setCond("Idle to Jump", !p.is_on_floor())
	setCond("Jump to Idle", p.is_on_floor())
	setCond("Idle to Walking", p.dir != 0)
	setCond("Walking to Idle", p.dir == 0)
	setCond("Walking to Jump", !p.is_on_floor())
	
	setCond("Idle to Punch", ajp)
	setCond("Walking to Punch", ajp)
	setCond("Jump to Punch", ajp)