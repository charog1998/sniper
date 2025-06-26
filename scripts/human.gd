extends Node2D
class_name Human

var screen_rect

var frame_index_parts = [0,0,0,0]
var color_parts = [Color.AQUA,Color.AQUA,Color.AQUA,Color.AQUA]
var is_target = false
var random_direction = ["up","down","left","right"]
var current_direction = "left"
var keep_direction = 0.7 # 保持原方向的概率，当大于这个概率时才重新抽取方向
var move_speed := 0

var is_focused = false

const COLORS = [Color.AQUA,Color.BLUE_VIOLET,Color.BROWN,Color.CADET_BLUE,Color.CHOCOLATE,Color.DARK_GREEN,Color.ORANGE]

func _ready() -> void:
	init()
	screen_rect = get_viewport_rect().size
	
func _process(delta: float) -> void:
	if is_focused:
		random_move(delta*move_speed/2)
	else:
		random_move(delta*move_speed)
	
func init(target:bool=false,direction_list:Array=["up","down","left","right"],position_range:Array=[200,200,1240,700],scale_range:Array=[0.1,0.2]):
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
	
	position = Vector2(randi_range(position_range[0],position_range[2]),randi_range(position_range[1],position_range[3]))
	var scale_choosed = randf_range(scale_range[0],scale_range[1])
	scale = Vector2(scale_choosed,scale_choosed)
	
	move_speed += 10
	$Lv.text = "Lv."+str(move_speed/10)
	
	return {"frame_index_parts":frame_index_parts,"color_parts":color_parts}
	
func random_move(distance):
	if randf()>keep_direction: # 每次有一定概率维持原方向
		current_direction = random_direction.pick_random()
	match current_direction:
		"up":
			position += Vector2(0,-distance)
		"down":
			position += Vector2(0,distance)
		"left":
			position += Vector2(-distance,0)
		"right":
			position += Vector2(distance,0)
			
	position = position.clamp(Vector2(0,0),screen_rect)
 


func _on_camera_with_cursor_focus_off() -> void:
	var new_tween = get_tree().create_tween()
	new_tween.tween_property($Focus_rect,"visible",false,0.1)
	is_focused = false


func _on_camera_with_cursor_focus_on() -> void:
	var new_tween = get_tree().create_tween()
	new_tween.tween_property($Focus_rect,"visible",true,0.7)
	is_focused = true
