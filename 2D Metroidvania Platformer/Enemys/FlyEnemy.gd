extends KinematicBody2D

var health = 3
var player = null
var speed = 1
var move = Vector2.ZERO

var knockbackPower = 50
var knockbackTime = 5
var hit = false

func _ready():
# warning-ignore:return_value_discarded
	$Timer.connect("timeout",self,"timerEnd")
	
# warning-ignore:unused_argument
func _physics_process(delta):
	if !hit:
		move = Vector2.ZERO
		if player != null:
			move = position.direction_to(player.position)
		elif player == null:
			move = Vector2.ZERO
		move = move.normalized()*speed
	else:
		if move.x > 0:
			move.x -= 0.1
		else:
			move.x += 0.1
# warning-ignore:return_value_discarded
	move_and_collide(move)

func _on_DetectPlayer_body_entered(body):
	if body != self:
		player = body

# warning-ignore:unused_argument
func _on_DetectPlayer_body_exited(body):
	player = null
	
func takeDamage(damage):
	health -= damage
	if player.position.x > position.x:
		move = Vector2(-2.6, 0)
	else:
		move = Vector2(2.6, 0)
	hit = true
	$Timer.start()		
	$AnimationPlayer.play("Hurt")

func timerEnd():
	hit = false
	$AnimationPlayer.play("defult")
	if health <= 0:
		var obj2 = preload("res://Enemys/Poof.tscn").instance()
		obj2.position = position
		get_parent().call_deferred("add_child", obj2)
		if rand_range(0, 100)>=75:
			var obj = preload("res://PowerUps/Heal.tscn").instance()
			obj.position = position
			get_parent().call_deferred("add_child", obj)
		queue_free()

func _on_DamageArea_body_entered(body):
	
	if body.has_method("takeDamage"):
		body.takeDamage(1, false, position, knockbackPower, knockbackTime)

