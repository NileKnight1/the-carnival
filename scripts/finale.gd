extends Node2D


var sound_retro_click = preload("res://audio/soundshelfstudio-ui-click-retro-514601.mp3")

func _ready() -> void:
	$CanvasLayer/patterns.visible = 0
	$CanvasLayer/health.visible = 0
	$CanvasLayer/hit_bar.visible = 0
	final_game()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("jump") && hit_bar:
		#print("jump")
		var dash_pos = $CanvasLayer/hit_bar/dash.position.x
		var zone = $CanvasLayer/hit_bar/zone.position.x
		if dash_pos >= zone && dash_pos <= zone+37:
			print("correct")
			hit_bar -= 1
			
			$CanvasLayer/hit_bar/zone.position.x = randi_range(-130, 100)
			
			
			if !hit_bar:
				hit_tween.kill()
				phase += 1
				final_game()
			
			var tween = create_tween()
			tween.tween_property($CanvasLayer/hit_bar, "rotation", deg_to_rad(5), 0.1)
			tween.tween_property($CanvasLayer/hit_bar, "rotation", deg_to_rad(-5), 0.1)
			tween.tween_property($CanvasLayer/hit_bar, "rotation", deg_to_rad(5), 0.1)
			tween.tween_property($CanvasLayer/hit_bar, "rotation", deg_to_rad(-5), 0.1)
			tween.tween_property($CanvasLayer/hit_bar, "rotation", deg_to_rad(0), 0.1)
			
			
		else:
			ghost_attack()

func play_sound(sound, vol = 0.0):
	var temp = AudioStreamPlayer.new()
	temp.stream = sound
	temp.volume_db = vol
	add_child(temp)
	
	temp.finished.connect(temp.queue_free)
	temp.play()

var hit_bar = 0
var hit_tween
var ghost_fight = 0

func final_game():
	ghost_fight = 1
	$CanvasLayer/health.visible = 1
	health = global.health
	#$map/Panel.visible = 1
	
	match phase:
		1: finale_phase1()
		2: finale_phase2()
		3: finale_phase3()

func finale_phase1():
	$CanvasLayer/hit_bar/zone.position.x = randi_range(-130, 100)
	$CanvasLayer/hit_bar.visible = 1
	hit_bar = 3
	hit_tween = create_tween().set_loops()
	hit_tween.tween_property($CanvasLayer/hit_bar/dash, "position:x", 136.0, 1.5)
	hit_tween.tween_property($CanvasLayer/hit_bar/dash, "position:x", -130.0, 1.5)

func finale_phase2():
	$CanvasLayer/hit_bar.visible = 0
	$CanvasLayer/patterns.visible = 1
	await get_tree().create_timer(1.0).timeout
	auto_light()

var health = global.health
func ghost_attack():
	print("health--")
	$CanvasLayer/health.get_child(health-1).visible = 0
	health-=1
	if health == 0:
		hit_tween.kill()
		hit_bar = 0


func check_click(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		return 1
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


func light(index, wait = 1):
	play_sound(sound_retro_click)
	var node = $CanvasLayer/patterns.get_child(index)
	print('lighted')
	node.modulate = Color(2,2,2,1.0)
	await get_tree().create_timer(0.6).timeout
	node.modulate = Color(1,1,1,1.0)
	if wait:
		await get_tree().create_timer(0.6).timeout
	

var lightened = [
	
]

var lighting_count = 5
func auto_light():
	pressed = 1
	for i in range(lighting_count):
		var temp = randi_range(0,3)
		print(temp)
		lightened.append(temp)
		await light(temp)
	print(lightened)
	pressed = 0

var phase = 1
var pressed = 1

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
				print("here")
				phase += 1
				final_game()
			else:
				ghost_attack()
		pressed = 0
	else:
		print("wrong")
		lightened.clear()
		auto_light()

func finale_phase3():
	$CanvasLayer/plushie.visible = 1
	$CanvasLayer/health.visible = 0
	
	$map/Panel.visible = 0
	$player/Camera2D.position = Vector2(0, -86)
	$player.position = Vector2(-298, -223)
	ghost_fight = 0
	$CanvasLayer/dark.visible = 0
