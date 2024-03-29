tool
extends "BaseBullet.gd"

export (float) var max_angular_speed
export (float) var angular_acceleration
export var random_direction = true

onready var smoke = get_node("Smoke")

var angular_speed = 0
var target = null

func _ready():
	if get_tree().is_editor_hint():
		return
	if random_direction:
		randomize()
		set_rot(rand_range(0, 2*PI))
	
func _process(delta):
	return
	var dir = Vector2(0, 1).rotated(get_rot())
	var req = (target.get_table_pos() - get_pos()).normalized()
	var angle =  req.angle_to(dir)

	if angle < 0:
		angular_speed = clamp(angular_speed + angular_acceleration * delta, -max_angular_speed, max_angular_speed)
	else:
		angular_speed = clamp(angular_speed - angular_acceleration * delta, -max_angular_speed, max_angular_speed)
	set_rot(get_rot() + angular_speed * delta)

func destroy():
	set_process(false)
	view.hide()
	explosion.explode()
	smoke.set_emitting(false)
	var timer = Timer.new()
	timer.set_wait_time(max(explosion.duration, smoke.get_lifetime()))
	timer.start()
	add_child(timer)
	yield(timer, "timeout")
	get_parent().remove_child(self)