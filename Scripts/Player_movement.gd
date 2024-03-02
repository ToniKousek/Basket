extends CharacterBody2D

@export var MAX_SPEED = 300.0
@export var ACCELERATION = 10.0
var speed = Vector2.ZERO

@onready var ball = get_parent().get_node("Ball")
@onready var findable_nodes = get_tree().get_nodes_in_group("findable")

@export var MUL_FOV_LINE = 500
@export var FOV = 90
enum LookAt {BALL, MOUSE}
var look_what: LookAt = LookAt.BALL
var direction = Vector2.ZERO
var angle = 0

signal ball_released

func _draw():
	draw_line(Vector2.RIGHT.rotated(deg_to_rad(FOV/2)) * MUL_FOV_LINE, Vector2.ZERO, Color.PINK, 5)
	draw_line(Vector2.RIGHT.rotated(deg_to_rad(-FOV/2)) * MUL_FOV_LINE, Vector2.ZERO, Color.PINK, 5)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if event.is_pressed():
				look_what = LookAt.MOUSE
			else:
				look_what = LookAt.BALL
		elif event.button_index == 2:
			if event.is_pressed():
				ball_released.emit()
				

func _process(delta):
	if look_what == LookAt.MOUSE or not ball:
		look_at(get_global_mouse_position())
		direction = (get_global_mouse_position() - position).normalized()
	elif look_what == LookAt.BALL and ball:
		look_at(ball.position)
		direction = (ball.position - position).normalized()
	
	angle = 90 - rad_to_deg(direction.angle())
	
	for node in findable_nodes:
		
		var direction_to_node = (node.position - position).normalized()
		var angle_to_node = rad_to_deg(direction.angle_to(direction_to_node))
		if abs(angle_to_node) < FOV/2:
			node.visible = true
		else:
			node.visible = false
	
	queue_redraw()


func _physics_process(delta):
	var direction = Input.get_vector("movement_left", "movement_right", "movement_up", "movement_down")
	
	for i in range(2):
		if direction[i]:
			speed[i] = move_toward(speed[i], MAX_SPEED * direction[i], ACCELERATION)
		else:
			speed[i] = move_toward(speed[i], 0, ACCELERATION)

	velocity = speed
	move_and_slide()
