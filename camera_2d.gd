extends Camera2D

var default_zoom: Vector2 = Vector2(1.2, 1.2)
var default_zoomed_zoom: Vector2 = Vector2(2, 2)
var current_zoom: Vector2 = Vector2(1.2, 1.2)
var zoom_speed: float = 5.0
var is_zooming: bool = false
const SPLIDE_STEP = 0.5 # 每次滚轮改变的缩放
const MAX_ZOOM = 5

signal focus
signal focus_off
signal fire

func _ready() -> void:
	current_zoom = default_zoom

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			is_zooming = event.pressed
			if is_zooming:
				current_zoom = default_zoomed_zoom
				$"../Timer".start(3)
				emit_signal("focus")
			else:
				end_focus()
		if is_zooming and event.button_index == MOUSE_BUTTON_WHEEL_UP:
			current_zoom = Vector2(current_zoom.x+SPLIDE_STEP,current_zoom.y+SPLIDE_STEP)
		if is_zooming and event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			current_zoom = Vector2(current_zoom.x-SPLIDE_STEP,current_zoom.y-SPLIDE_STEP)
		if is_zooming:
			current_zoom = Vector2(clamp(current_zoom.x,default_zoom.x*2,MAX_ZOOM),clamp(current_zoom.y,default_zoom.y*2,MAX_ZOOM))
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			emit_signal("fire")
		

func _process(delta):	
	zoom = zoom.lerp(current_zoom, zoom_speed * delta)
	position = get_viewport().get_mouse_position()
	$"../cursor".position = position
	
func end_focus():
	current_zoom = default_zoom
	$"../Timer".stop()
	emit_signal("focus_off")
	
