extends StaticBody2D
var right = false
var left = false
var done = 0

func _ready():
# warning-ignore:return_value_discarded
	$Timer.connect("timeout",self,"timerEnd")
	$Timer.start()
	
# warning-ignore:unused_argument
func _on_CheckRight_body_entered(body):
	right = true


# warning-ignore:unused_argument
func _on_CheckLeft_body_entered(body):
	left = true

func timerEnd():
	if left and !right:
		get_node("SideWood").visible = true
		get_node("MidWood").visible = false
	elif right and !left:
		get_node("SideWood").visible = true
		get_node("MidWood").visible = false
		scale.x = -scale.x
	else:
		get_node("MidWood").visible = true
	
		

