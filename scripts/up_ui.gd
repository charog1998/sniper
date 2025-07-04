extends CanvasLayer

const WIND_STEP := 0.1
const WIND_DEFAULT := Vector2(3.0, 3.0)
const WIND_INTENSITY := 0.1 # 表示风力变化程度，抽取一个数字如果小于这个常量再变化风力

var wind_current = Vector2(3.0, 3.0)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	wind_current = WIND_DEFAULT


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var changed = randf() < WIND_INTENSITY
	var up_or_down
	var left_or_right
	var change_offset = Vector2(0.0, 0.0)
	var temp_rand = randf()
	if temp_rand < 0.25:
		up_or_down = WIND_STEP
		left_or_right = WIND_STEP
	elif temp_rand < 0.5:
		up_or_down = WIND_STEP
		left_or_right = -WIND_STEP
	elif temp_rand < 0.75:
		up_or_down = -WIND_STEP
		left_or_right = WIND_STEP
	elif temp_rand < 1.0:
		up_or_down = -WIND_STEP
		left_or_right = -WIND_STEP
	if changed:
		change_offset = Vector2(left_or_right,up_or_down)
	wind_current += change_offset
	wind_current.clampf(-3.0,3.0)
	wind_current.snappedf(0.1)
	show_wind()
	
func show_wind():
	var wind_length = wind_current.distance_to(Vector2.ZERO)/3.0/1.414 # 风向条的长度
	$WindStrengthLabel.text = str(round(wind_current.distance_to(Vector2.ZERO)))
	
	if wind_length < 0.7:
		wind_length = 0.7
	$WindStrength.scale = Vector2(wind_length, 1.0)
	$WindStrength.rotation = wind_current.angle()
	#print(wind_current.distance_to(Vector2.ZERO))
	
