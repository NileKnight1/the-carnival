extends Node2D

var sound_start = preload("res://audio/start.mp3")
var sound_game_over = preload("res://audio/universfield-game-over-deep-male-voice-clip-352695.mp3")
var sound_retro_click = preload("res://audio/soundshelfstudio-ui-click-retro-514601.mp3")

func play_sound(sound, vol = 0.0):
	var temp = AudioStreamPlayer.new()
	temp.stream = sound
	temp.volume_db = vol
	add_child(temp)
	
	temp.finished.connect(temp.queue_free)
	temp.play()


func check_click(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		return 1

func _ready() -> void:
	#light($table/buttons/b1)
	#light($table/buttons/b2)
	#light($table/buttons/b3)
	#light($table/buttons/b4)
	
	$CanvasLayer/dark.visible = 1
	$CanvasLayer/start_menu.visible = 1
	#$CanvasLayer/score.visible = 0
	#$CanvasLayer/highest.visible = 1
	#start_game()
	

func start_game():
	lighting_count = 1
	print("start")
	play_sound(sound_start)
	$CanvasLayer/dark.visible = 0
	$CanvasLayer/start_menu.visible = 0
	$CanvasLayer/restart_menu.visible = 0
	
	#await get_tree().create_timer(0.5).timeout #edit
	#$CanvasLayer/score.visible = 1
	await get_tree().create_timer(0.5).timeout #edit
	game_running = 1
	auto_light()
	

func _process(delta: float) -> void:
	pass

func light(index, wait = 1):
	play_sound(sound_retro_click)
	var node = $table/buttons.get_child(index)
	print('lighted')
	node.modulate = Color(2,2,2,1.0)
	await get_tree().create_timer(0.6).timeout
	node.modulate = Color(1,1,1,1.0)
	if wait:
		await get_tree().create_timer(0.6).timeout
	

var lightened = [
	
]

var lighting_count = 1
func auto_light():
	pressed = 1
	for i in range(lighting_count):
		var temp = randi_range(0,3)
		print(temp)
		lightened.append(temp)
		await light(temp)
	print(lightened)
	pressed = 0

var pressed = 0

func man_light(index):
	if pressed: return
	pressed = 1
	await light(index, 0)
	if index == lightened[0]:
		lightened.remove_at(0)
		print("correct")
		if lightened == []:
			await get_tree().create_timer(0.6).timeout
			if lighting_count == 5:
				win()
			else:
				lighting_count += 1
				auto_light()
		pressed = 0
	else:
		print("wrong")
		lightened.clear()
		auto_light()
		

func _on_button_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if check_click(event):
		man_light(0)
func _on_button_2_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if check_click(event):
		man_light(1)
func _on_button_3_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if check_click(event):
		man_light(2)
func _on_button_4_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if check_click(event):
		man_light(3)

func win():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	play_sound(sound_game_over)
	$CanvasLayer/dark.visible = 1
	$CanvasLayer/restart_menu.visible = 1
	game_running = 0
	

var game_running = 0
func _on_start_pressed() -> void:
	start_game()

func _on_leave_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")
