extends Component

func _ready():
	p.connect("jumpCounterChanged", self, "updateJumpBar")
	
	$Playername.text = String(p.playerID+1)
	$JumpCBar.max_value = p.mxjmp

func updateJumpBar():
	$JumpCBar/Tween.interpolate_property($JumpCBar, "value", $JumpCBar.value, p.mxjmp-p.jmpc, .3, Tween.TRANS_EXPO, Tween.EASE_OUT)
	$JumpCBar/Tween.start()