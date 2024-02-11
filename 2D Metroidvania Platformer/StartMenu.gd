extends Control



func _on_NewGame_button_up():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Level-1.tscn")


func _on_Quit_button_up():
	get_tree().quit()
