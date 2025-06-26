extends Camera2D

var default_zoom: Vector2 = Vector2(1.1, 1.1)
var default_zoomed_zoom: Vector2 = Vector2(2, 2)
var current_zoom: Vector2 = Vector2(1.1, 1.1)
var zoom_speed: float = 5.0
var is_zooming: bool = false

var focus_time = 3.0 # 瞄准时间

var current_score = 0

const SPLIDE_STEP = 0.5 # 每次滚轮改变的缩放
const MIN_ZOOM = 1.0 # 最小的缩放倍率
const MAX_ZOOM = 5.0 # 最大的缩放倍率

signal fire
signal focus_on
signal focus_off

func _ready() -> void:
	current_zoom = default_zoom
	current_score = 0
	show_score("")
	#$Cursor.get_node("AnimationPlayer").play_backwards("focus")
	
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			is_zooming = event.pressed
			if is_zooming:
				current_zoom = default_zoomed_zoom
				$FocusTimer.start(focus_time)
				start_focus()
			else:
				end_focus()

		if is_zooming and event.button_index == MOUSE_BUTTON_WHEEL_UP:
			current_zoom = Vector2(current_zoom.x+SPLIDE_STEP,current_zoom.y+SPLIDE_STEP)
		if is_zooming and event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			current_zoom = Vector2(current_zoom.x-SPLIDE_STEP,current_zoom.y-SPLIDE_STEP)
		if is_zooming: # 限制下滚轮的缩放上下限
			current_zoom = Vector2(clamp(current_zoom.x,default_zoomed_zoom.x,MAX_ZOOM),clamp(current_zoom.y,default_zoomed_zoom.y,MAX_ZOOM))
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			start_fire()
			
func _draw() -> void:
	draw_circle(Vector2.ZERO, 2, Color.RED)

func _process(delta):	
	$Cursor.get_node("CircleProgressBar").value = 100*$FocusTimer.time_left/3
	
	zoom = zoom.lerp(current_zoom, zoom_speed * delta)
	position = get_viewport().get_mouse_position()
	
func start_focus():
	$Cursor.get_node("AnimationPlayer").play("focus")
	emit_signal("focus_on")
	
func end_focus():
	current_zoom = default_zoom
	$FocusTimer.stop()
	$Cursor.get_node("AnimationPlayer").play_backwards("focus")
	is_zooming = false
	emit_signal("focus_off")
	
func start_fire():
	var human_center = get_human_at_center()
	if human_center is Human:
		current_score += human_center.move_speed
		show_score(human_center.move_speed)
		human_center.init()

	var init_pos = position
	var fire_x_offset = randi_range(-20,20)
	var fire_y_offset = randi_range(-20,20)
	var new_tween = get_tree().create_tween()
	new_tween.tween_property(self,"position",Vector2(init_pos.x+fire_x_offset,init_pos.y+fire_y_offset),0.05)
	
func get_human_at_center()->Human:
	var center_pos := global_position
	var space_state := get_world_2d().direct_space_state
	var query := PhysicsPointQueryParameters2D.new()
	query.position = center_pos
	query.collide_with_areas = true
	query.collide_with_bodies = true
	#query.collision_mask = 0b1
	var result := space_state.intersect_point(query)
	for hit in result:
		if hit.collider is Human:
			return hit.collider
	return null
	
func show_score(add_score):
	var new_tween = get_tree().create_tween()
	new_tween.tween_property($ScoreLabel,"text","SCORE："+str(current_score),0.1)
