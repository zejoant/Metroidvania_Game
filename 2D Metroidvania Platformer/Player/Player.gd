extends KinematicBody2D

enum Ani {Waking, Idel, Jump, Fall, Land, Death, ShootUp, ShootDown, ShootSide, Dash, WallJump}

# Declare member variables here. Examples:
var speed = 125
var gravity = 10
var gravityMod1 = 2
var gravityMod2 = 1.5
var jumpPower = 250
var velocity = Vector2(0,0)
var look = true
var jumpBuffer = 0
var land = 0
var attackcooldown = 0
var ani = Ani.Idel
var maxHealth = 6
var health = 6
var swordDamage = 1
var maxYSpeed = 1500
var is_on_floor = 0
var is_on_floor_right = false
var is_on_floor_left = false
var lastSafePos = Vector2(0, 0)
var maxJumpCounter = 0
var jumpCounter = 0
var maxDashCounter = 0
var dashCounter = 0
var dash = 0
var dashDir = 1
var wallJump = false
var noControlTime = 30
var debugmode = false
var move = true
var gun = true
var gunOn = false
var velocitySaveForRocket = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	$Camera2D/UI/Control/TextureProgress.max_value = maxHealth
	$Camera2D/UI/Control/TextureProgress.value = health
	$Camera2D/CanvasModulate.color = Color("ffffff")
	$HurtEffect.region_rect = Rect2(128, -80, 16, 16)
	yield(get_tree(), "idle_frame")
	$AnimationPlayer.play("Idel")
	pass # Replace with function body.


# warning-ignore:unused_argument
func _physics_process(delta):
	if ani == Ani.Death:
# warning-ignore:return_value_discarded
		move_and_slide(Vector2(0, gravity*5), Vector2(0, -1))
		return
	elif debugmode:
		debugMovment()
		return
	elif !move:
		return
	_movement()
	if Input.is_action_just_pressed("debug"):
			$AnimationPlayer.play("Land")
			debugmode = true
	
	pass

func debugMovment():
	if Input.is_action_pressed("left"):
		velocity += Vector2.LEFT * speed * 2
		if attackcooldown == 0:
			ani = Ani.Waking
			if look == true:
				scale.x *=-1
				dashDir *=-1
				look = false
	if Input.is_action_pressed("right"):
		velocity += Vector2.RIGHT * speed * 2
		if attackcooldown == 0:
			ani = Ani.Waking
			if look == false:
				scale.x *=-1
				dashDir *=-1
				look = true
	if Input.is_action_pressed("up"):
		velocity += Vector2.UP * speed * 2
		if attackcooldown == 0:
			ani = Ani.Waking
			if look == false:
				scale.x *=-1
				dashDir *=-1
				look = true
	if Input.is_action_pressed("down"):
		velocity += Vector2.DOWN * speed * 2
		if attackcooldown == 0:
			ani = Ani.Waking
			if look == false:
				scale.x *=-1
				dashDir *=-1
				look = true
# warning-ignore:return_value_discarded
	velocitySaveForRocket = velocity.x
	move_and_slide(velocity, Vector2(0, -1))
	velocity = Vector2.ZERO
	if Input.is_action_just_pressed("debug"):
			debugmode = false



func _movement():
	if is_on_floor_right and is_on_floor_left:
		lastSafePos = position
	is_on_floor_right = false
	is_on_floor_left = false
			
	if velocity == Vector2.ZERO:
		ani = Ani.Idel
	
	walk()
	
	jump()
	
# warning-ignore:return_value_discarded
	move_and_slide(velocity, Vector2(0, -1))
	
	if Input.is_action_just_pressed("attack") and attackcooldown == 0:
		attackcooldown = 20
		gun = false
	elif attackcooldown > 0:
		attackcooldown -= 1
	

	if Input.is_action_just_pressed("Shoot") and gunOn:
		var obj = load("res://Player/Bullet.tscn").instance()
		if Input.is_action_pressed("up"):
			obj.dir = Vector2.UP*4
			obj.position = Vector2(position.x-3*dashDir, position.y-10)
		elif Input.is_action_pressed("down") and is_on_floor == 0:
			obj.dir = Vector2.DOWN*4
			obj.position = Vector2(position.x-3*dashDir, position.y+10)
		else:
			obj.dir = Vector2(dashDir*4, 0)
			obj.position = Vector2(position.x+9*dashDir, position.y+4)
		attackcooldown = 10
		gun = true
		get_tree().get_root().call_deferred("add_child", obj)
				
	
	if noControlTime > 0:
		noControlTime -= 1
		if Input.is_action_pressed("right") and velocity.x < speed:
			velocity.x += speed*2/10
		if Input.is_action_pressed("left") and velocity.x > -speed:
			velocity.x -= speed*2/10
	else:
		velocity.x = 0
	
	if is_on_ceiling():
		velocity = Vector2.DOWN * gravity
	_animations()
	pass

func walk():
	if abs(dash) > speed or noControlTime > 0:
		return
	if Input.is_action_pressed("left"):
		velocity += Vector2.LEFT * speed
		if attackcooldown == 0:
			ani = Ani.Waking
			if look == true:
				scale.x *=-1
				dashDir *=-1
				look = false
	if Input.is_action_pressed("right"):
		velocity += Vector2.RIGHT * speed
		if attackcooldown == 0:
			ani = Ani.Waking
			if look == false:
				scale.x *=-1
				dashDir *=-1
				look = true


func jump():
	if is_on_floor > 0:
		velocity.y = 0
		jumpCounter = maxJumpCounter
		if abs(dash) < speed:
			dashCounter = maxDashCounter
	if !is_on_wall() or !wallJump:
		maxYSpeed = 1500
	elif is_on_wall():
		maxYSpeed = 100
		if Input.is_action_just_pressed("jump") and is_on_floor == 0:
			velocity.y = -jumpPower
			jumpCounter += 1
			if look:
				velocity.x = -speed*2
			else:
				velocity.x = speed*2
			noControlTime = 10
			dashCounter = maxDashCounter
			yield(get_tree(), "idle_frame")
			yield(get_tree(), "idle_frame")
			jumpCounter = maxJumpCounter			
			pass
	
	if Input.is_action_just_pressed("jump"):
		if is_on_floor > 0:
			jumpBuffer = 5
		elif jumpCounter > 0:
			jumpCounter -= 1
			jumpBuffer = 5
	
	if jumpBuffer > 0:
		velocity.y = -jumpPower
		jumpBuffer = 0
		land = 0
	if velocity.y > maxYSpeed:
		velocity.y = maxYSpeed
	elif is_on_floor == 0:
		if !Input.is_action_pressed("jump"):
			velocity += Vector2.DOWN * gravity * gravityMod1
		elif velocity.y > 0:
			velocity += Vector2.DOWN * gravity * gravityMod2
		else:
			velocity += Vector2.DOWN * gravity
	
	if is_on_floor == 0:
		if velocity.y < 0:
			ani = Ani.Jump
		elif is_on_wall() and wallJump:
			ani=Ani.WallJump
		elif velocity.y > 0:
			ani = Ani.Fall
		land = 10
		jumpBuffer -= 1
	elif land > 0:
		ani = Ani.Land
		land -= 1
	
	
	if Input.is_action_just_pressed("Dash") and dashCounter > 0:
		dash = 400*dashDir
		dashCounter-=1
	if abs(dash) > speed:
		ani=Ani.Dash
		velocity.x = dash
		velocity.y = 0
		dash -= 20*dashDir
	else:
		dash = 0



func _on_RoomDetector_area_entered(area):
	var collision_shape = area.get_node("CollisionShape2D")
	var size = collision_shape.shape.extents*2
	
	var cam = $Camera2D
	cam.limit_top = collision_shape.global_position.y - size.y/2
	cam.limit_left = collision_shape.global_position.x - size.x/2
	
	cam.limit_bottom = cam.limit_top + size.y
	cam.limit_right = cam.limit_left + size.x


func _on_upSword_body_entered(body):
	if body.has_method("takeDamage"):
		body.takeDamage(swordDamage)
	
func _on_downSword_body_entered(body):
	if body.has_method("takeDamage"):
		body.takeDamage(swordDamage)
		velocity.y = -jumpPower

func _on_Sword_body_entered(body):
	if body.has_method("takeDamage"):
		body.takeDamage(swordDamage)



func _animations():	
	if attackcooldown > 0:
		if attackcooldown == 20:
			if Input.is_action_pressed("up"):
				$AnimationPlayer.play("UpAttack")
				pass
			elif Input.is_action_pressed("down") and is_on_floor == 0:
				$AnimationPlayer.play("DownAttack")
				pass
			else:
				match ani:
					Ani.Idel:
						$AnimationPlayer.play("Attack")
					Ani.Jump:
						$AnimationPlayer.play("JumpAttack")
					Ani.Fall:
						$AnimationPlayer.play("JumpAttack")
					Ani.Land:
						$AnimationPlayer.play("Attack")
					Ani.Waking:
						$AnimationPlayer.play("WakingAttack")
					Ani.Death:
						$AnimationPlayer.play("Death")
					Ani.WallJump:
						$AnimationPlayer.play("WallJump")
					Ani.Dash:
						$AnimationPlayer.play("Dash")
		elif attackcooldown == 10 and gun:
			if Input.is_action_pressed("up"):
				$AnimationPlayer.play("GunUp")
				pass
			elif Input.is_action_pressed("down") and is_on_floor == 0:
				$AnimationPlayer.play("GunDown")
				pass
			else:
				$AnimationPlayer.play("Gun")
			
	else:
		match ani:
			Ani.Idel:
				$AnimationPlayer.play("Idel")
			Ani.Waking:
				$AnimationPlayer.play("Waking")
			Ani.Jump:
				$AnimationPlayer.play("Jump")
			Ani.Fall:
				$AnimationPlayer.play("Fall")
			Ani.Land:
				$AnimationPlayer.play("Land")
			Ani.Death:
				$AnimationPlayer.play("Death")
			Ani.WallJump:
				$AnimationPlayer.play("WallJump")
			Ani.Dash:
				$AnimationPlayer.play("Dash")

# warning-ignore:unused_argument
func takeDamage(damage, safeLand, knockback, knockbackPower, knockbackTime):
	health -= damage
	$Camera2D/UI/Control/TextureProgress.value = health
	$HurtEffect2.play("HurtExplosion")
	get_tree().paused = true
	for i in 8:
		yield(get_tree(), "idle_frame")
	get_tree().paused = false
	noControlTime = knockbackTime
	var x = position.x - knockback.x
	var y = position.y - knockback.y
	knockback = Vector2(x/2, y/2)*knockbackPower
	velocity = knockback
	if health <= 0:
		ani = Ani.Death
		$AnimationPlayer.play("Death")
	if safeLand:
		position = lastSafePos


func doubleJump():
	maxJumpCounter += 1

# warning-ignore:function_conflicts_variable
func dash():
	maxDashCounter += 1

# warning-ignore:function_conflicts_variable
func wallJump():
	wallJump = true

func damageUp():
	swordDamage += 1

func heal():
	if health != maxHealth:
		health += 1
		$Camera2D/UI/Control/TextureProgress.value = health

func hpUp():
	maxHealth += 1
	health = maxHealth
	$Camera2D/UI/Control/TextureProgress.max_value = maxHealth
	$Camera2D/UI/Control/TextureProgress.value = health

func GunNar():
	gunOn = true

# warning-ignore:unused_argument
func _on_Is_on_floor_body_entered(body):
	is_on_floor += 1


# warning-ignore:unused_argument
func _on_Is_on_floor_body_exited(body):
	is_on_floor -= 1


# warning-ignore:unused_argument
func _on_is_on_floor_right_body_entered(body):
	is_on_floor_right = true


# warning-ignore:unused_argument
func _on_is_on_floor_left_body_entered(body):
	is_on_floor_left = true
	pass # Replace with function body.

func collisionOnOff(var name, var path):
	move = false
	$TileColl.disabled = true
	$Camera2D.smoothing_enabled = false	
	get_node("Camera2D/Transition").transition(name, path)
	for i in 20:
		yield(get_tree(), "idle_frame")
	$TileColl.disabled = false	
	move = true
	$Camera2D.smoothing_enabled = true	

func _on_AnimationPlayer_animation_finished(anim_name):
	if health <= 0:
		get_node("Camera2D/Transition").deathFade(health)
