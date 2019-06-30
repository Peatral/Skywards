extends Character

class_name CharacterBase

func onAttackJustPressed():
	.onAttackJustPressed()
	
	if attackRay.is_colliding():
		if attackRay.get_collider() is PlayerController:
			attackRay.get_collider().call_deferred("applyImpulse", pc.lastDir)

func _process(delta):
	attackRay.cast_to = Vector2(40*pc.lastDir, 0)
	
	if pc != null && self.sprite != null:
		if pc.dir != 0:
			self.sprite.flip_h = pc.dir < 0