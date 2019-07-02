extends Component

class_name Character

export(NodePath) onready var sprite = get_node(sprite)
export(NodePath) onready var animationPlayer = get_node(animationPlayer)
export(NodePath) onready var stateMachine = get_node(stateMachine)
export(NodePath) onready var attackRay = get_node(attackRay)
export var kbWaitTime = 1.0

var ajp = false
var sjp = false
var sjr = false

func _ready():
	updateSignals()
	$KnockBackTimer.wait_time = kbWaitTime

func updateSignals():
	p.connect("attackJustPressed", self, "onAttackJustPressed")
	p.connect("specialJustPressed", self, "onSpecialJustPressed")
	p.connect("specialJustReleased", self, "onSpecialJustReleased")
	p.connect("died", self, "onDied")
	p.connect("landed", self, "onLanded")

func onAttackJustPressed():
	ajp = true

func onSpecialJustPressed():
	sjp = true

func onSpecialJustReleased():
	sjr = true

func onLanded(lastVel):
	pass

func onDied():
	pass

func setCond(condName, val):
	if stateMachine != null:
		stateMachine.set("parameters/conditions/" + condName, val)

func resetInputs():
	ajp = false
	sjp = false
	sjr = false

func onKBTimerTimeout():
	p.increaseKnockback()

func _process(delta):
	resetInputs()