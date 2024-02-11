extends Area2D

var aim
var speed = Vector2(-5, 0)
var playerSpeed = 0
var once = true

func _ready():
	$AnimatedSprite.play("default")
	aim = get_tree().get_root().get_node("Map/Player").position
	#speed.x = (aim.x - position.x)/75
	rotation = -PI/2
	
func _physics_process(_delta):
	if once:
		if aim.x < 200:
			aim.x -= (aim.x - get_tree().get_root().get_node("Map/Player").position.x)*90
		once = false
	
	position += speed
	if speed.x < 0 and position.x - aim.x < 100:
		speed.x = (aim.x-5 - position.x)/25
	if speed.y < 3.3 and position.x - aim.x < 200:
		speed.y += 0.040
	elif speed.y > 2.3:
		var obj = preload("res://Explosion.tscn").instance()
		obj.position = position
		get_parent().call_deferred("add_child", obj)
		queue_free()
	rotation = atan2(speed.y, speed.x)+PI/2
