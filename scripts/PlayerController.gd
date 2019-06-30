extends KinematicBody2D

class_name PlayerController

var vel = Vector2()
var dir = 1
var lastDir = 1

var jumping = false
var impulse = false

var hclt = 0

var knockback = 0 setget setKnockback

onready var start = position

export var  acc = 10
export var  dec = 30
export var  air = 20
export var  frc = 15
export var  tpx = 300
export var  tpy = 1500
export var  grv = 55 
export var  jmp = 1000
export var  jmpc = 0 setget setJumpC
export var  mxjmp = 10
export var dead = false
export var particleScene = preload("res://Particles.tscn")

export(int, "Player 1", "Player 2") var playerID = 0

signal knockbackChanged
signal attackJustPressed
signal specialJustPressed
signal specialJustReleased
signal died
signal jumpCounterChanged

func setJumpC(val):
	jmpc = val
	emit_signal("jumpCounterChanged")

func applyImpulse(d):
	if !impulse:
		vel += Vector2(500*d, -750)*sqrt(knockback+1)
		impulse = true
		hclt = .4
		dir = d

func getAction(action):
	match action:
		"right":
			return "game_right" if playerID == 0 else "game_right_2"
		"left":
			return "game_left" if playerID == 0 else "game_left_2"
		"jump":
			return "game_jump" if playerID == 0 else "game_jump_2"
		"attack":
			return "game_attack" if playerID == 0 else "game_attack_2"
		"special":
			return "game_special" if playerID == 0 else "game_special_2"
	return ""

func getDirection():
	return Input.get_action_strength(getAction("right"))-Input.get_action_strength(getAction("left"))

func die():
	if !dead:
		var particles = particleScene.instance()
		particles.position = position-Vector2(0, 40)
		if particles is Particles2D:
			particles.emitting = true
		get_tree().root.call_deferred("add_child", particles)
		self.jmpc = 0
		dead = true
		
		emit_signal("died")

func resetPosition():
	position = start

func resetVelocity():
	vel = Vector2(0, 0)
	impulse = false
	jumping = false

func setKnockback(val):
	knockback = val
	emit_signal("knockbackChanged", knockback)

func increaseKnockBack():
	self.knockback = min(knockback+1, 100)

func _ready():
	self.jmpc = 0

func _physics_process(delta):
	
	if hclt == 0:
		dir = getDirection()
	
	if is_on_ceiling():
		vel.y = 0
	
	if is_on_floor() && !impulse:
		vel.y = 0
		self.jmpc = 0
		jumping = false
		
		if dir != 0:
			#Acceleration, Deceleration
			vel.x += dec*dir if sign(dir) == sign(vel.x)*-1 else acc*dir
		else:
			#Friction
			vel.x -= min(frc, abs(vel.x))*sign(vel.x)
	
	else:
		#Acceleration
		if dir != 0:
			vel.x += air*dir
		
		#Jump Velocity
		if jumping && !Input.is_action_pressed(getAction("jump")):
			vel.y = max(vel.y, -500)
			jumping = false
		
		#Gravity
		vel.y += grv
		
		#Top Y-Speed
		vel.y = min(vel.y, tpy)
		
		#Air Drag
		if vel.y < 0 && vel.y > -600:
			if abs(vel.x) > 125: vel.x *= 0.9
	
	#Jumping
	if Input.is_action_just_pressed(getAction("jump")) && jmpc < mxjmp:
		jumping = true
		impulse = false
		vel.y = -jmp
		self.jmpc += 1
	
	#Top X Speed
	if dir != 0: vel.x = min(max(vel.x, -tpx), tpx)
	
	if hclt > 0: hclt -= min(delta, hclt)
	else: 
		impulse = false
		hclt = 0
	
	if dir != 0: lastDir = sign(dir)
	
	var snap = Vector2(0,15) if !(impulse && jumping) else Vector2()
	move_and_slide_with_snap(vel, snap, Vector2(0, -1))

func _process(delta):
	if Input.is_action_just_pressed(getAction("attack")):
		emit_signal("attackJustPressed")
	if Input.is_action_just_pressed(getAction("special")):
		emit_signal("specialJustPressed")
	if Input.is_action_just_released(getAction("special")):
		emit_signal("specialJustReleased")
	
	if position.y < 0 || position.y > 5000 || (is_on_ceiling() && vel.y < -1000):
		die()



