extends TileMap
class_name InteractiveTilemap2
var rotationArray = [PI, true]

export(Dictionary) var TILE_SCENES := {
	0: preload("res://Enemys/enemy.tscn"),
	1: preload("res://Enemys/FlyEnemy.tscn"),
	2: preload("res://Spike.tscn"),
	3: preload("res://PowerUps/Heal.tscn"),
	4: preload("res://PowerUps/DamageUp.tscn"),
	5: preload("res://PowerUps/DoubleJump.tscn"),
	6: preload("res://PowerUps/Dash.tscn"),
	7: preload("res://PowerUps/WallJump.tscn"),
	8: preload("res://Enemys/GroundEnemy.tscn"),
	9: preload("res://Semi-Solid.tscn"),
	10: preload("res://PowerUps/HpUp.tscn"),
	11: preload("res://Enemys/BulletEnemy.tscn"),
	12: preload("res://Enemys/BounceEnemy.tscn"),
	13: preload("res://PowerUps/GunPowerUp.tscn"),
	14: preload("res://BreakableBlock.tscn"),
	15: preload("res://Enemys/RollEnemy.tscn"),
}

onready var half_cell_size := cell_size * 0.5

var enemys = []
func _ready():
	yield(get_tree(), "idle_frame")
	_replace_tiles_with_scenes()
	visible = false

func _replace_tiles_with_scenes(scene_dictionary: Dictionary = TILE_SCENES):
	for tile_pos in get_used_cells():
		var tile_id = get_cell(tile_pos.x, tile_pos.y)
		
		if scene_dictionary.has(tile_id):
			var object_scene = scene_dictionary[tile_id]
			_replace_tile_with_object(tile_id, tile_pos, object_scene)

# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _replace_tile_with_object(tile_id: int, tile_pos: Vector2, object_scene: PackedScene, parent: Node = get_tree().current_scene):
#	if get_cellv(tile_pos/4) != INVALID_CELL:
#		set_cellv(tile_pos/4, -1)
#		#update_bitmask_region()

	#Spawns the object
	if object_scene:
		var obj = object_scene.instance()
		var ob_pos = map_to_world(tile_pos) + half_cell_size
# warning-ignore:narrowing_conversion
# warning-ignore:narrowing_conversion
# warning-ignore:narrowing_conversion
# warning-ignore:narrowing_conversion
# warning-ignore:narrowing_conversion
# warning-ignore:narrowing_conversion
		rotationArray = getRotation(is_cell_x_flipped(tile_pos.x, tile_pos.y), is_cell_y_flipped(tile_pos.x, tile_pos.y), is_cell_transposed (tile_pos.x, tile_pos.y))
		obj.rotation = rotationArray[0]
		if rotationArray[1]:
			obj.set_scale(Vector2(1, -1))
		
		owner.add_child(obj)
		obj.visible = true
		obj.global_position = ob_pos
		
static func getRotation(xflip, yflip, transpose)->Array:
	if (!xflip and !transpose):
		return [0.0, yflip]
	elif (xflip  and !transpose):
		return [PI, !yflip]
	elif (!xflip and transpose):
		return [-PI/2, !yflip]
	else: # elif (xflip and transpose):
		return [PI/2, yflip]    
