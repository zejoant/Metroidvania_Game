extends Area2D


func _ready():
	$AnimationPlayer.play("Poof")
	
# warning-ignore:unused_argument
func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
