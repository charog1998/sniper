extends Node2D

var mouse_warped = true

func _input(event):
	if event.is_action_pressed("esc"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if event.is_action_pressed("enter_game"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
	if event.is_action_pressed("f1"):
		$CameraWithCursor.position = $Human.position
		$CameraWithCursor.start_fire()
		$CameraWithCursor.position = $Human2.position
		$CameraWithCursor.start_fire()
		$CameraWithCursor.position = $Human3.position
		$CameraWithCursor.start_fire()
		
		


func _ready() -> void:
	var viewport_size := get_viewport().get_visible_rect().size
	var center := viewport_size / 2
	Input.warp_mouse(center)
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
	

func _process(delta: float) -> void:
	pass
	#if mouse_warped:
		#var mouse_pos = get_viewport().get_mouse_position()
		#var viewport_size = get_viewport().size
		#
		## 检查鼠标是否超出边界
		#if mouse_pos.x < 0 or mouse_pos.x > viewport_size.x or mouse_pos.y < 0 or mouse_pos.y > viewport_size.y:
		## 将鼠标位置限制在屏幕内
			#var clamped_pos = Vector2(
				#clamp(mouse_pos.x, 0, viewport_size.x),
				#clamp(mouse_pos.y, 0, viewport_size.y)
				#)
			#Input.warp_mouse(clamped_pos)

func _on_camera_with_cursor_focus() -> void:
	pass # Replace with function body.


func _on_camera_with_cursor_focus_off() -> void:
	pass # Replace with function body.


func _on_camera_with_cursor_focus_on() -> void:
	pass # Replace with function body.
