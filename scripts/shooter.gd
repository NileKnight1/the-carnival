extends Node2D

var sound_start = preload("res://audio/start.mp3")
var sound_shot = preload("res://audio/dragon-studio-gunshot-504030.mp3")
var sound_game_over = preload("res://audio/universfield-game-over-deep-male-voice-clip-352695.mp3")
var sound_pop = preload("res://audio/universfield-bubble-pop-06-351337.mp3")

func play_sound(sound, vol = 0.0):
	var temp = AudioStreamPlayer.new()
	temp.stream = sound
	temp.volume_db = vol
	add_child(temp)
	
	temp.finished.connect(temp.queue_free)
	temp.play()

@onready var gun: Sprite2D = $"CanvasLayer/341994"


var shake_intensity = 0.0
var active_shake_time = 0.0
var shake_decay = 5.0
var shake_time = 0.0
var shake_time_speed = 20.0
var noise = FastNoiseLite.new()

func screen_shake(intensity, time):
	randomize()
	noise.seed = randi()
	noise.frequency = 2.0
	shake_intensity = intensity
	active_shake_time = time
	shake_time = 0.0

var current_targets = 0

func _process(delta: float) -> void:
	# y: rotation -21.2: 7.2
	# y:-45:92
	#$"CanvasLayer/341994".rotation = 
	#print(targets_list)
	
	var mouse_x = get_global_mouse_position().x
	var mouse_y = get_global_mouse_position().y

	var shaked = $"Camera2D"
	if active_shake_time > 0:
		shake_time += delta * shake_time_speed
		active_shake_time -= delta
		shaked.position = Vector2(
			noise.get_noise_2d(shake_time, 0.0) * shake_intensity,
			noise.get_noise_2d(0.0, shake_time) * shake_intensity
		)
		
		shake_intensity = max(shake_intensity - shake_decay * delta, 0.0)
	else:
		shaked.position = shaked.position.lerp(Vector2.ZERO, 10.5 * delta)
	#shaked = $CanvasLayer
	#if active_shake_time > 0:
		#shake_time += delta * shake_time_speed
		#active_shake_time -= delta
		#
		#shaked.offset = Vector2(
			#noise.get_noise_2d(shake_time, 0.0) * shake_intensity,
			#noise.get_noise_2d(0.0, shake_time) * shake_intensity
		#)
		#shake_intensity = max(shake_intensity - shake_decay * delta, 0.0)
	#else:
		#shaked.offset = shaked.offset.lerp(Vector2.ZERO, 10.5 * delta)
	#
#
	#if mouse_y > -45 and mouse_y < 110:
		#gun.rotation = remap(mouse_y, -45, 110, 5.9, 6.3)
	#else:
		#gun.rotation = 0
	#
	
	# حركات المسدس
	gun.rotation = remap(mouse_y, -45, 110, 5.9, 6.3)
	gun.position.x = remap(mouse_x, -320, -15, -50, 396.0)
	
	
	# -320:-15
	# pos.x  -31.0:396.0
	#print(gun.rotation)
	#print(get_global_mouse_position())
	#
	#if Input.is_action_just_pressed("click"):
		#print("x")

# البتاع دي لو عايز تستقبل كليك شمال على area مثلا
func check_click(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		return 1

func _on_target_test_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if check_click(event):
		print()

func _ready() -> void:
	gun.visible = 0
	$CanvasLayer/dark.visible = 1
	$CanvasLayer/start_menu.visible = 1
	$CanvasLayer/score.visible = 0
	$CanvasLayer/highest.visible = 1
	


func start_game():
	time = 30
	gun.visible = 1
	play_sound(sound_start)
	$CanvasLayer/dark.visible = 0
	$CanvasLayer/start_menu.visible = 0
	$CanvasLayer/restart_menu.visible = 0
	
	#await get_tree().create_timer(0.5).timeout #edit
	$CanvasLayer/score.visible = 1
	#await get_tree().create_timer(0.5).timeout #edit
	game_running = 1
	$CanvasLayer/time.visible = 1
	
	$game_time.start()
	spawn_apply()

var game_running = 0

func game_over():
	play_sound(sound_game_over)
	gun.visible = 0
	$CanvasLayer/dark.visible = 1
	$CanvasLayer/restart_menu.visible = 1
	game_running = 0
	$game_time.stop()
	for i in $targets.get_children():
		i.queue_free()

var max_targets = 1

# هنا البتاعة الي بتتحكم ف الوقت بين ظهور تارجت وتارجت
func spawn_apply():
	
	while current_targets != max_targets:
		if !game_running: return
		spawn_target()
	
	
	await get_tree().create_timer(2.5).timeout
	spawn_apply()

# هنا البتاعة الي بترسبن تارجت
var target = preload("res://scenes/target.tscn")
func spawn_target():
	current_targets += 1
	var temp = target.instantiate()
	var tempy = randi_range(0, 2)
	# بيrandomize الارتفاع على تلت احتمالات (الصفوف يعني)
	match tempy:
		0: tempy = 22
		1: tempy = -38
		2: tempy = 81
	
	temp.game = self
	temp.position.x = randi_range(-28.0, -310.0)
	temp.position.y = tempy
	
	var temp_skin = randi_range(0, 2)
	temp.get_node("skins").get_child(temp_skin).visible = 1
	
	temp.id = target_id
	var temp_id = temp.id
	target_id += 1
	targets_list.append(1)
	$targets.add_child(temp)
	
	await get_tree().create_timer(3.0).timeout
	if targets_list[temp_id] && game_running:
		#print(temp_id)
		temp.queue_free()
		current_targets -= 1

var target_id = 0

var targets_list = [
	
]

var highest_score = 0
var score = 0

func update_score():
	score += 1
	#تحديث الui
	$CanvasLayer/score.text = "Score: " + str(score)
	var tween = create_tween()
	tween.tween_property($CanvasLayer/score, "scale", Vector2(1.05,1.05), 0.1)
	tween.tween_property($CanvasLayer/score, "scale", Vector2(1,1), 0.1)
	
func shoot():
	screen_shake(2, 1)
	play_sound(sound_shot)
	
	var temp = gun.get_node("smoke").duplicate()
	
	temp.restart()
	temp.emitting = true
	gun.add_child(temp)
		
	$"CanvasLayer/341994/light".visible = 1
	await get_tree().create_timer(0.1).timeout
	$"CanvasLayer/341994/light".visible = 0
	
	await get_tree().create_timer(3).timeout
	temp.queue_free()
	

func target_hit():
	shoot()
	update_score()
	
	play_sound(sound_pop)
	await get_tree().create_timer(0.5).timeout
	if current_targets < max_targets && game_running:
		spawn_target()

func miss_hit():
	shoot()
	minus_score()

func minus_score():
	score -= 1
	$CanvasLayer/score.text = "Score: " + str(score)
	var tween = create_tween()
	tween.tween_property($CanvasLayer/score, "position:x", 15, 0.1)
	tween.tween_property($CanvasLayer/score, "position:x", 45, 0.1)
	tween.tween_property($CanvasLayer/score, "position:x", 33, 0.1)
	

var time = 30
func _on_game_time_timeout() -> void:
	time -= 1 
	$CanvasLayer/time.text = ""
	if time < 10: $CanvasLayer/time.text = str(0) 
	$CanvasLayer/time.text += str(time)
	if time == 0:
		game_over()
		
	if time > 20:
		max_targets = 1
	elif time > 10:
		max_targets = 2
	else:
		max_targets = 3


func _on_start_pressed() -> void:
	start_game()

func _on_leave_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")

var handeled = 0
var gun_shot = preload("res://assets/Gunshot-PNG-Picture.png")

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if check_click(event) && game_running:
		print("got click")
		var temp = Sprite2D.new()
		temp.texture = gun_shot
		temp.position =  get_global_mouse_position()
		temp.scale = Vector2(0.029,0.029)
		$shots.add_child(temp)
		
		await get_tree().create_timer(0.01).timeout
		if !handeled:
			
			miss_hit()
		else: handeled = 0
		
		await get_tree().create_timer(3).timeout
		$shots.get_child(0).queue_free()
