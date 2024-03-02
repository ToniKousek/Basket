extends Area2D

var following_player: Node2D
@export var BALL_OFFSET = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var bodies = get_overlapping_bodies()
	if !following_player:
		for body in bodies:
			if body.is_in_group("people"):
				following_player = body
	
	if following_player:
		position = following_player.position + following_player.direction * BALL_OFFSET


func _on_player_ball_released():
	position = position + following_player.direction * BALL_OFFSET
	following_player = null
	
