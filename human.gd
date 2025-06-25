extends Node2D

var frame_index_parts = [0,0,0,0]
var color_parts = [Color.AQUA,Color.AQUA,Color.AQUA,Color.AQUA]
var is_target = false
var random_direction = ["up","down","left","right"]

const COLORS = [Color.AQUA,Color.BLUE_VIOLET,Color.BROWN,Color.CADET_BLUE,Color.CHOCOLATE,Color.DARK_GREEN,Color.ORANGE]



func _ready() -> void:
	init()
	
func init(target:bool=false,direction_list:Array=["up","down","left","right"]):
	is_target = target
	random_direction = direction_list
	
	frame_index_parts[0] = randi_range(0,7)
	frame_index_parts[1] = randi_range(0,7)
	frame_index_parts[2] = randi_range(0,7)
	color_parts[0] = COLORS.pick_random()
	color_parts[1] = COLORS.pick_random()
	color_parts[2] = COLORS.pick_random()
	color_parts[3] = COLORS.pick_random()
	
	$Hair.set_frame_coords(Vector2i(frame_index_parts[0], 0))
	$Head.set_frame_coords(Vector2i(frame_index_parts[1], 1))
	$Body.set_frame_coords(Vector2i(frame_index_parts[2], 2))
	$Legs.set_frame_coords(Vector2i(frame_index_parts[3], 3))
	$Hair.set_modulate(color_parts[0])
	$Head.set_modulate(color_parts[1])
	$Body.set_modulate(color_parts[2])
	$Legs.set_modulate(color_parts[3])
	
	return {"frame_index_parts":frame_index_parts,"color_parts":color_parts}
	
func random_move(distance):
	var new_direction = random_direction.pick_random()
	match new_direction:
		"up":
			position += Vector2(0,-distance)
		"down":
			position += Vector2(0,distance)
		"left":
			position += Vector2(-distance,0)
		"right":
			position += Vector2(distance,0)
 
