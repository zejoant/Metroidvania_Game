extends StaticBody2D


func _ready():
	pass

func _on_BulletDetection_area_entered(_area):
	var obj = load("res://Enemys/Poof.tscn").instance()
	obj.position = position
	get_parent().call_deferred("add_child", obj)
	queue_free()
