extends Component

var amplitude = 0

func start(duration=.2, frequency=15, amplitude=10):
	self.amplitude = amplitude
	
	$Frequency.wait_time = 1/float(frequency)
	$Duration.wait_time = duration
	
	$Frequency.start()
	$Duration.start()
	
	newShake()

func newShake():
	var rand = Vector2()
	rand.x = rand_range(-amplitude, amplitude)
	rand.y = rand_range(-amplitude, amplitude)
	
	$Tween.interpolate_property(p, "offset", p.offset, rand, $Frequency.wait_time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Tween.start()

func reset():
	$Tween.interpolate_property(p, "offset", p.offset, Vector2(), $Frequency.wait_time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Tween.start()

func onFrequencyTimeout():
	newShake()

func onDurationTimeout():
	reset()
	$Frequency.stop()