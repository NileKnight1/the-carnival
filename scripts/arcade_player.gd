extends CharacterBody2D


const SPEED = 50.0
const JUMP_VELOCITY = -100.0

var move = 0
 
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta/3
	
	if !move: return
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	#var direction_y := Input.get_axis("up", "down")
	#if direction_y:
		#velocity.y = direction_y * SPEED
	#else:
		#velocity.y = move_toward(velocity.y, 0, SPEED)
	#
	#
	#var direction_x := Input.get_axis("left", "right")
	#if direction_x:
		#velocity.x = direction_x * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
	#
	

	move_and_slide()
