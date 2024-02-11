extends TileMap
class_name InteractiveTilemap

func _ready():
	yield(get_tree(), "idle_frame")
	for cell in get_used_cells_by_id(20):
		var particle_position = to_global(map_to_world(Vector2(cell.x+1, cell.y)))
		var new_particle = load("res://VineParticles.tscn").instance()
		new_particle.global_position = particle_position
		add_child(new_particle)
	

