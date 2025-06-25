extends Node2D

var mouse_warped = true

func _input(event):
	if event.is_action_pressed("esc"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
	$cursor.get_node("AnimationPlayer").play("RESET")

func _process(delta: float) -> void:
	$cursor.get_node("ProgressBar").value = 100*$Timer.time_left/3
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

func _on_camera_2d_focus() -> void:
	$cursor.get_node("AnimationPlayer").play("focus")

func _on_camera_2d_focus_off() -> void:
	$cursor.get_node("AnimationPlayer").play_backwards("focus")


func _on_camera_2d_fire() -> void:
	var init_pos = $cursor.position
	var fire_offset = randi_range(-20,20)
	var new_tween = get_tree().create_tween()
	new_tween.tween_property($cursor,"position",Vector2(init_pos.x+fire_offset,init_pos.y-20),0.05)
	new_tween.tween_property($cursor,"position",init_pos,0.05)


func _on_change_1_pressed() -> void:
	print($Human.init(true,["up","down"]))


func _on_change_2_pressed() -> void:
	$Human.random_move(10)
