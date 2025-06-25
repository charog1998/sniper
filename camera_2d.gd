extends Camera2D

var default_zoom: Vector2 = Vector2(1.2, 1.2)
var zoomed_zoom: Vector2 = Vector2(2, 2)
var zoom_speed: float = 5.0
var is_zooming: bool = false
const SPLIDE_STEP = 0.5 # 每次滚轮改变的缩放
const MAX_ZOOM = 5

signal focus
signal focus_off
signal fire

func _ready() -> void:
	zoomed_zoom = default_zoom

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			is_zooming = event.pressed
			if is_zooming:
				zoomed_zoom = zoomed_zoom*2
				$"../Timer".start(3)
				emit_signal("focus")
			else:
				end_focus()
		if is_zooming and event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoomed_zoom = Vector2(zoomed_zoom.x+SPLIDE_STEP,zoomed_zoom.y+SPLIDE_STEP)
		if is_zooming and event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoomed_zoom = Vector2(zoomed_zoom.x-SPLIDE_STEP,zoomed_zoom.y-SPLIDE_STEP)
		zoomed_zoom = Vector2(clamp(zoomed_zoom.x,default_zoom.x,MAX_ZOOM),clamp(zoomed_zoom.y,default_zoom.y,MAX_ZOOM))
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			emit_signal("fire")
		

func _process(delta):	
	zoom = zoom.lerp(zoomed_zoom, zoom_speed * delta)
	position = get_viewport().get_mouse_position()
	$"../cursor".position = position
	
func end_focus():
	zoomed_zoom = default_zoom
	$"../Timer".stop()
	emit_signal("focus_off")
	
