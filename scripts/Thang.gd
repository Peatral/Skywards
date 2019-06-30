extends Area2D

var collected = false

func _on_Thang_body_entered(body):
	if !collected && body is PlayerController:
		$AnimationPlayer.play("Destroy")
		collected = true
		body.knockback = max(body.knockback-int(rand_range(10, 15)), 0)
