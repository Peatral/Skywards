extends KinematicBody2D

var vel = Vector2()
var dir = 1
var lastDir = 1
const acc = 10
const dec = 30
const air = 20
const frc = 15
const tpx = 300
const tpy = 1500
const grv = 55 
const jmp = 1000
var jmpc = 0
const mxjmp = 10

var jumping = false
var impulse = false

var hclt = 0

puppet var slvPos = Vector2()
puppet var slvVel = Vector2()
puppet var slvDir = 1
var current_anim = ""
var player_name setget set_player_name

func set_player_name(val):
	player_name = val
	$Playername.text = player_name

func _ready():
	slvPos = position

func applyImpulse(dir):
	vel += Vector2(500*dir, -1000)
	impulse = true
	hclt = 30

func _physics_process(delta):
	if (is_network_master()):
		if hclt == 0:
			if Input.is_action_pressed("game_left"):
				dir = -1
			elif Input.is_action_pressed("game_right"):
				dir = 1
			else:
				dir = 0
		
		if is_on_ceiling():
			vel.y = 0
		
		if is_on_floor():
			vel.y = 0
			jmpc = 0
			jumping = false
			
			if dir != 0:
				#Acceleration, Deceleration
				vel.x += dec*dir if dir == sign(vel.x)*-1 else acc*dir
			else:
				#Friction
				vel.x -= min(frc, abs(vel.x))*sign(vel.x)
		
		else:
			#Acceleration
			if dir != 0:
				vel.x += air*dir
			
			#Jump Velocity
			if jumping && !Input.is_action_pressed("game_jump"):
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
		if Input.is_action_just_pressed("game_jump") && jmpc < mxjmp:
			jumping = true
			impulse = false
			vel.y = -jmp
			jmpc += 1
		
		#Top X Speed
		if dir != 0: vel.x = min(max(vel.x, -tpx), tpx)
		
		if Input.is_action_just_pressed("ui_focus_next"):
			applyImpulse(lastDir)
		
		if hclt > 0: hclt -= 1
		else: impulse = false
	
		
		rset("slvVel", vel)
		rset("slvPos", position)
		rset("slvDir", dir)
	else:
		position = slvPos
		vel = slvVel
		dir = slvDir
	
	if dir != 0: lastDir = dir
	
	var snap = Vector2(0,15) if !(impulse && jumping) else Vector2()
	move_and_slide_with_snap(vel, snap, Vector2(0, -1))
	
	#move_and_slide(vel, Vector2(0, -1))
	
	if (not is_network_master()):
		slvPos = position # To avoid jitter

func _process(delta):
	if dir != 0:
		$OG.flip_h = dir == -1
	
	
	var anim = ""
	if !is_on_floor():
		anim = "Jump"
	else:
		if vel.x != 0:
			anim = "Walking"
		else:
			anim = "Idle"
	
	if (anim != current_anim):
		current_anim = anim
		$AnimationPlayer.play(current_anim)
