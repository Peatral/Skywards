extends Control

var kb = 0 setget setKBVal

func setKBVal(val):
	kb = val
	$KBBar/Tween.interpolate_property($KBBar, "value", $KBBar.value, kb, .3, Tween.TRANS_EXPO, Tween.EASE_OUT)
	$KBBar/Tween.start()
