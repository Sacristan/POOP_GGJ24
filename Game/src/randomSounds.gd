extends AudioStreamPlayer

@export var minDelay: float = 1
@export var maxDelay: float = 10

@export var clips: Array[AudioStream]

func _ready():
	while(true):
		await Global.wait(getDelay())
		stream = randomClip()
		play()
		await finished
		
func randomClip():
	return clips[randi() % clips.size()]
	
func getDelay():
	randomize()
	return randf_range(minDelay, maxDelay)
