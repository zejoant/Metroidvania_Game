extends KinematicBody2D

var knockbackPower = 50
var knockbackTime = 5
var health = 20
var rng = RandomNumberGenerator.new()
var attacking = false
var attack
var attackMem

var chainTimer = 50
var sequence = 0
var projectileAmount = 10
var chainOut = 0

var objLoad = preload("res://Enemys/Rocket.tscn")
var enemy1Load = preload("res://Enemys/RollEnemy.tscn")

func _ready():
	$AnimationPlayer.play("Move")
	$Arm1Under.offset.x = 0
	$Particles2D.emitting = false
	$Particles2D2.emitting = false

# warning-ignore:unused_argument
func _physics_process(delta):
	if  position.x > 432:
		position.x -= 0.5
	elif position.x == 432:
# warning-ignore:standalone_expression
		position.x == 432
		if attacking == false:
			nextAttack()
		else:
			if attack == 1:
				shoot_chain()
			elif attack == 2:
				shoot_missiles()
			elif attack == -1:
				retract_chain()
			elif attack == 3:
				enemy_hatch()
			else:
				attacking = false

func _on_Damage_body_entered(body):
	if body.has_method("takeDamage"):
		body.takeDamage(1, false, position, knockbackPower, knockbackTime)

func nextAttack():
	attacking = true
	rng.randomize()
# warning-ignore:unused_variable
	while attack == attackMem:
		attack = rng.randi_range(1,3)
		
	if chainOut == 2:
		attack = -1
	if chainOut == 1:
		chainOut = 2
		if attack == 1:
			attack = rng.randi_range(2,3)
	attackMem = attack

func shoot_chain():
	if sequence == 0:
		$AnimationPlayer.play("ChainCharge")
		sequence = 1
		
	if sequence == 1 and !$AnimationPlayer.is_playing():
		$AnimationPlayer.play("ChainShoot")
		sequence = 2
		chainOut = 1
		attacking = false
		sequence = 0

func retract_chain():
	if sequence == 0 and !$AnimationPlayer.is_playing():
		$AnimationPlayer.play_backwards("ChainShoot")
		sequence = 1

	if sequence == 1 and !$AnimationPlayer.is_playing():
		attacking = false
		sequence = 0
		chainOut = 0
	
func shoot_missiles():
	if sequence == 0:
		$AnimationPlayer2.play("OpenMouth")
		sequence = -1
	if sequence == -1 and !$AnimationPlayer2.is_playing():
		sequence = 1
	
	if sequence == 1 and projectileAmount > 0:
		var obj = objLoad.instance()
		obj.position = Vector2(position.x-8, position.y-37)
		get_parent().call_deferred("add_child", obj)
		sequence = 41
		projectileAmount -= 1
	elif sequence > 1:
		sequence -= 1
	
	if projectileAmount == 0 and sequence != -2:
		$AnimationPlayer2.play_backwards("OpenMouth")
		sequence = -2
	
	if sequence == -2 and !$AnimationPlayer2.is_playing():
		projectileAmount = 10
		attacking = false
		sequence = 0

func enemy_hatch():
	if sequence == 0:
		$AnimationPlayer2.play("OpenHatch")
		sequence = 1
		projectileAmount = 8
	if projectileAmount > 0 and sequence == 1 and !$AnimationPlayer2.is_playing():
		var obj = enemy1Load.instance()
		obj.position = position
		get_parent().call_deferred("add_child", obj)
		sequence = 40
		projectileAmount -= 2
	elif sequence > 1:
		sequence -= 1
	if projectileAmount == 0:
		$AnimationPlayer2.play_backwards("OpenHatch")
		projectileAmount = -1
	if projectileAmount == -1 and !$AnimationPlayer2.is_playing():
		attacking = false
		projectileAmount = 10
		sequence = 0
