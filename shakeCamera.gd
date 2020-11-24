extends Camera2D

export var decay = 1.5
export var max_offset = Vector2(20, 14)
export var max_roll = 0.1
export (NodePath) var target # use for a following camera
var trauma = 0.0
var trauma_pow = 1.8 
var startPosition = Vector2()

onready var noise = OpenSimplexNoise.new()
var noise_y = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	noise.seed = randi() #def=0
	noise.period = 4 #def=64
	noise.octaves = 2 #def=3
	noise.lacunarity = 2 #def=2
	noise.persistence - 0.5 #def=0.5
	startPosition = position

func add_trauma(amount):
	trauma = min(trauma + amount, 1.0)

func shake():
	var amount = pow(trauma, trauma_pow) #always <= 1
	noise_y += 1
	rotation = max_roll * amount * noise.get_noise_2d(noise.seed, noise_y)
	offset.x = max_offset.x * amount * noise.get_noise_2d(noise.seed * 2, noise_y)
	offset.y = max_offset.y * amount * noise.get_noise_2d(noise.seed * 3, noise_y)
	#needed for a static camera
	if(!target):
		position.x = startPosition.x + offset.x
		position.y = startPosition.y + offset.y


func _process(delta):
	if target:
		global_position = get_node(target).global_position
	if trauma:
		shake()
		trauma = max(trauma - decay * delta, 0)
