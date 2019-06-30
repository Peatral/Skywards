extends Node2D

class_name Character

export(NodePath) onready var pc = get_node(pc)
export(NodePath) onready var sprite = get_node(sprite)
export(NodePath) onready var animationPlayer = get_node(animationPlayer)
export(NodePath) onready var stateMachine = get_node(stateMachine)
export(NodePath) onready var attackRay = get_node(attackRay)
export var indicatorOffset = -58 setget setIndicatorOffset

var ajp = false
var sjp = false
var sjr = false

func _ready():
	$Indicators/Playername.text = String(pc.playerID+1)
	$Indicators/JumpCBar.max_value = pc.mxjmp
	updateSignals()

func setIndicatorOffset(val):
	indicatorOffset = val
	$Indicators.position.y = indicatorOffset

func updateSignals():
	if pc != null:
		pc.connect("attackJustPressed", self, "onAttackJustPressed")
		pc.connect("specialJustPressed", self, "onSpecialJustPressed")
		pc.connect("specialJustReleased", self, "onSpecialJustReleased")
		pc.connect("died", self, "onDied")
		pc.connect("jumpCounterChanged", self, "updateJumpBar")

func updateJumpBar():
	$Indicators/JumpCBar/Tween.interpolate_property($Indicators/JumpCBar, "value", $Indicators/JumpCBar.value, pc.mxjmp-pc.jmpc, .3, Tween.TRANS_EXPO, Tween.EASE_OUT)
	$Indicators/JumpCBar/Tween.start()

func onAttackJustPressed():
	ajp = true

func onSpecialJustPressed():
	sjp = true

func onSpecialJustReleased():
	sjr = true

func onDied():
	pass

func setCond(condName, val):
	if stateMachine != null:
		stateMachine.set("parameters/conditions/" + condName, val)

func resetInputs():
	ajp = false
	sjp = false
	sjr = false

func _process(delta):
	resetInputs()