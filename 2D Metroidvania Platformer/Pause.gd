extends Control


func _input(event):
	if event.is_action_pressed("pause"):
		get_tree().paused = !get_tree().paused
		visible = get_tree().paused



func _on_Resume_button_up():
	get_tree().paused = !get_tree().paused
	visible = get_tree().paused
	pass # Replace with function body.


func _on_Quit_button_up():
	get_tree().quit()
