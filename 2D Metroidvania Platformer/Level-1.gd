extends Node


var obj
# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree(), "idle_frame")
	obj = preload("res://Rooms/Room Scenes/Room1.tscn").instance()
	add_child(obj)
	obj.global_position = Vector2(0, 0)
	VisualServer.set_default_clear_color(Color("6b837e"))
	
#
func _on_MainMenu_button_up():
	get_tree().paused = false
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Menu/StartMenu.tscn")
	
