extends KinematicBody2D

# Exports
export(int) var WALK_SPEED = 50
export(int) var RUN_SPEED = 70

# Internals
var state := "default"
var move_dir := Vector2.ZERO
var last_dir := Vector2.ZERO
var is_running := false

# Nodes
onready var sprite := $AnimatedSprite

func _physics_process(delta):
	match state:
		"default":
			state_default()

# ------------- STATES ------------- #
func state_default():
	loop_controls()
	loop_movement()
	loop_sprite_dir()
	#loop_interact()
	
	#if move_dir.length() == 1:
		#ray.cast_to = move_dir * 8
	
	if move_dir == Vector2.ZERO:
		anim_switch("idle")
	else:
		anim_switch("run") if is_running else anim_switch("walk")

#------------- LOOPS -------------
func loop_movement():
	var motion: Vector2
	if move_dir != Vector2.ZERO:
		last_dir = move_dir
	motion = move_dir.normalized() * (RUN_SPEED if is_running else WALK_SPEED)
	move_and_slide(motion)


func loop_sprite_dir():
	sprite.flip_h = last_dir.x < 0

func loop_controls():
	move_dir = Vector2.ZERO
	
	var LEFT = Input.is_action_pressed("ui_left")
	var RIGHT = Input.is_action_pressed("ui_right")
	var UP = Input.is_action_pressed("ui_up")
	var DOWN = Input.is_action_pressed("ui_down")
	
	move_dir.x = -int(LEFT) + int(RIGHT)
	move_dir.y = -int(UP) + int(DOWN)
	
	is_running = Input.is_action_pressed("run")

func anim_switch(anim_name: String):
	sprite.set_animation(anim_name)

#func loop_interact():
#	if ray.is_colliding():
#		var collider = ray.get_collider()
#		if collider.get_parent().is_in_group("interact") && collider is Area2D && Input.is_action_just_pressed("interact") && action_cooldown == 0:
#			collider.get_parent().interact(self)
