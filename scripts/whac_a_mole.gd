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


var current_targets = 0

@onready var hammer = $CanvasLayer/hammer

func _process(delta: float) -> void:
	var mouse_x = get_global_mouse_position().x
	var mouse_y = get_global_mouse_position().y
	#print(mouse_x)
	print(mouse_y)
	# حركات المسدس
	#hammer.rotation = remap(mouse_y, -45, 110, 5.9, 6.3)
	#hammer.position.x = remap(mouse_x, 73, 1200, -360, 350)
	hammer.position.x = remap(mouse_x, -367, 367, 13, 1288)
	hammer.position.y = remap(mouse_y, -207, 207, 35, 750)
	
	

func _ready() -> void:
	#gun.visible = 0
	$CanvasLayer/dark.visible = 1
	$CanvasLayer/start_menu.visible = 1
	$CanvasLayer/score.visible = 0
	$CanvasLayer/highest.visible = 1
	#spawn_target()
	#spawn_target()
	#spawn_target()
	#spawn_target()
	#spawn_target()
	#spawn_target()
	
	pass
	

# البتاع دي لو عايز تستقبل كليك شمال على area مثلا
func check_click(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		return 1

func _on_target_test_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if check_click(event):
		print()

func start_game():
	#gun.visible = 1
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
	#gun.visible = 0
	$CanvasLayer/dark.visible = 1
	$CanvasLayer/restart_menu.visible = 1
	game_running = 0
	$game_time.stop()
	for i in $targets.get_children():
		i.queue_free()

var max_targets = 1

func spawn_apply():
	
	while current_targets != max_targets:
		if !game_running: return
		spawn_target()
	
	
	await get_tree().create_timer(2.5).timeout
	spawn_apply()

var target = preload("res://scenes/target.tscn")
func spawn_target():
	current_targets += 1
	print('spawned')
	var tempy
	
	while 1:
		tempy = randi_range(0,$down/holes.get_child_count()-1)
		if $down/holes.get_child(tempy).get_node("mask").get_child_count() == 1:
			break
	
	#tempy = 0
	var temp = $down/holes.get_child(tempy).get_node("mask").get_child(0).duplicate()
	print(temp)
	
	temp.game = self
	temp.template = 0
	var tempx = temp.position.y
	
	var tween = create_tween()
	tween.tween_property(temp, "position:y", tempx-30, 0.7)
	
	var temp_skin = randi_range(0, 2)
	temp.get_node("skins").get_child(temp_skin).visible = 1
	
	temp.id = target_id
	var temp_id = temp.id
	target_id += 1
	targets_list.append(1)
	$down/holes.get_child(tempy).get_node("mask").add_child(temp)
	
	print($down/holes/hole/mask.get_children())
	
	await get_tree().create_timer(3.0).timeout
	if targets_list[temp_id] && game_running:
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
	play_sound(sound_shot)
	
	#var temp = gun.get_node("smoke").duplicate()
	
	#temp.restart()
	#temp.emitting = true
	#gun.add_child(temp)
		
	#$"CanvasLayer/341994/light".visible = 1
	#await get_tree().create_timer(0.1).timeout
	#$"CanvasLayer/341994/light".visible = 0
	
	await get_tree().create_timer(3).timeout
	#temp.queue_free()
	

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
