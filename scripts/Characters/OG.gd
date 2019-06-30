extends CharacterBase

func onDied():
	stateMachine.get("parameters/playback").start("Spawn")

func _process(delta):
	
	setCond("Idle to Jump", !pc.is_on_floor())
	setCond("Jump to Idle", pc.is_on_floor())
	setCond("Idle to Walking", pc.dir != 0)
	setCond("Walking to Idle", pc.dir == 0)
	setCond("Walking to Jump", !pc.is_on_floor())
	
	setCond("Idle to Punch", ajp)
	setCond("Walking to Punch", ajp)
	setCond("Jump to Punch", ajp)