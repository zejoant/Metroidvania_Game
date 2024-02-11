extends CanvasLayer

var anim_finished = false
var place
var path
var obj
var playerHealth = 500
var bossSong = preload("res://Audio/Everhood_The_Final_Battle.mp3")
var gameplaySong = preload("res://Audio/Iceous_Cave.mp3")

func _ready():
	$AnimationPlayer.play("fade_to_normal")
	$AudioStreamPlayer.stream = gameplaySong
	$AudioStreamPlayer.play()
	
func transition(var n, var p):
	place = n
	path = p
	$AnimationPlayer.play("fade_to_black")

func deathFade(var health):
	playerHealth = health
	$AnimationPlayer.play("fade_to_black")
	


func _on_AnimationPlayer_animation_finished(anim_name):
	if playerHealth <= 0:
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Level-1.tscn")
		
	if playerHealth > 0:
		if anim_name == "fade_to_normal":
			anim_finished = false
		if anim_name == "fade_to_black":
			anim_finished = true
			
			if place == "1R1":
				get_parent().get_parent().position = Vector2(8, 80)
				obj = load("res://Rooms/Room Scenes/Room2.tscn").instance()
			
			if place == "1L1":
				get_parent().get_parent().position = Vector2(952, 224)
				obj = load("res://Rooms/Room Scenes/Room3.tscn").instance()
				VisualServer.set_default_clear_color(Color("9d806c"))
				
			if place == "1U1":
				get_parent().get_parent().position = Vector2(168, 480)
				obj = load("res://Rooms/Room Scenes/Room7.tscn").instance()
				VisualServer.set_default_clear_color(Color("646c83"))
			
			if place == "2L1":
				get_parent().get_parent().position = Vector2(472, 224)
				obj = load("res://Rooms/Room Scenes/Room1.tscn").instance()
			
			if place == "2L2":
				get_parent().get_parent().position = Vector2(1460, 128)
				obj = load("res://Rooms/Room Scenes/Room5.tscn").instance()
			
			if place == "2L3":
				get_parent().get_parent().position = Vector2(1460, 432)
				obj = load("res://Rooms/Room Scenes/Room5.tscn").instance()
			
			if place == "2R1":
				get_parent().get_parent().position = Vector2(8, 272)
				obj = load("res://Rooms/Room Scenes/Room4.tscn").instance()
			
			if place == "2R2":
				get_parent().get_parent().position = Vector2(8, 48)
				obj = load("res://Rooms/Room Scenes/Room4.tscn").instance()
			
			if place == "3R1":
				get_parent().get_parent().position = Vector2(8, 224)
				obj = load("res://Rooms/Room Scenes/Room1.tscn").instance()
				VisualServer.set_default_clear_color(Color("6b837e"))
				
			if place == "3L1":
				get_parent().get_parent().position = Vector2(504, 48)
				obj = load("res://Rooms/Room Scenes/Room6.tscn").instance()
			
			if place == "3L2":
				get_parent().get_parent().position = Vector2(504, 224)
				obj = load("res://Rooms/Room Scenes/Room6.tscn").instance()
			
			if place == "3D1":
				get_parent().get_parent().position = Vector2(408, 16)
				obj = load("res://Rooms/Room Scenes/Room5.tscn").instance()
				VisualServer.set_default_clear_color(Color("6b837e"))
			
			if place == "4L1":
				get_parent().get_parent().position = Vector2(472, 528)
				obj = load("res://Rooms/Room Scenes/Room2.tscn").instance()
			
			if place == "4L2":
				get_parent().get_parent().position = Vector2(472, 304)
				obj = load("res://Rooms/Room Scenes/Room2.tscn").instance()
			
			if place == "5R1":
				get_parent().get_parent().position = Vector2(8, 232)
				obj = load("res://Rooms/Room Scenes/Room2.tscn").instance()
				
			if place == "5R2":
				get_parent().get_parent().position = Vector2(8, 528)
				obj = load("res://Rooms/Room Scenes/Room2.tscn").instance()
			
			if place == "5U1":
				get_parent().get_parent().position = Vector2(136, 224)
				obj = load("res://Rooms/Room Scenes/Room3.tscn").instance()
				
			if place == "6R1":
				get_parent().get_parent().position = Vector2(8, 224)
				obj = load("res://Rooms/Room Scenes/Room3.tscn").instance()
			
			if place == "6R2":
				get_parent().get_parent().position = Vector2(8, 48)
				obj = load("res://Rooms/Room Scenes/Room3.tscn").instance()
			
			if place == "7D1":
				get_parent().get_parent().position = Vector2(120, 16)
				obj = load("res://Rooms/Room Scenes/Room1.tscn").instance()
				VisualServer.set_default_clear_color(Color("6b837e"))
			
			if place == "7R1":
				get_parent().get_parent().position = Vector2(8, 224)
				obj = load("res://Rooms/Room Scenes/Room8 (Boss).tscn").instance()
				VisualServer.set_default_clear_color(Color("6b837e"))
				$AudioStreamPlayer.stop()
				$AudioStreamPlayer.stream = bossSong
				$AudioStreamPlayer.play()
			
			if place == "8L1":
				get_parent().get_parent().position = Vector2(1112, 272)
				obj = load("res://Rooms/Room Scenes/Room7.tscn").instance()
				
			get_parent().get_parent().get_parent().call_deferred("add_child", obj)
			path.queue_free()
			obj = null
				
			for n in 10:
				yield(get_tree(), "idle_frame")
			$AnimationPlayer.play("fade_to_normal")
