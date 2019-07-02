extends Character

class_name CharacterBase

export var attackRayLength = 40.0

func onAttackJustPressed():
	.onAttackJustPressed()
	
	if attackRay.is_colliding():
		if attackRay.get_collider() is PlayerController:
			attackRay.get_collider().call_deferred("applyImpulse", p.lastDir)

func _process(delta):
	attackRay.cast_to = Vector2(attackRayLength*p.lastDir, 0)
	
	if p != null && self.sprite != null:
		if p.dir != 0:
			self.sprite.flip_h = p.dir < 0