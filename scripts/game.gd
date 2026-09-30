extends Node2D

var sound_retro_click = preload("res://audio/soundshelfstudio-ui-click-retro-514601.mp3")

func play_sound(sound, vol = 0.0):
	var temp = AudioStreamPlayer.new()
	temp.stream = sound
	temp.volume_db = vol
	add_child(temp)
	
	temp.finished.connect(temp.queue_free)
	temp.play()


var game2_location
var game3_location
var game4_location

# الي يضيف لعبة يعدل هنا بس
func assign_games_data():
	# game 2
	$map/tent2.visible = 1
	$map/tent2/info/title.text = ""
	$map/tent2/info/info2.text = ""
	$map/tent2/info/info3.text = ""
	#$map/tent2/info/image.texture = ""
	game2_location = "scenes/whac_a_mole.tscn"
	
	# game 3
	$map/tent3.visible = 1
	$map/tent3/info/title.text = "Game Title"
	$map/tent3/info/info2.text = "Small desribtion."
	$map/tent3/info/info3.text = "Highest score/etc"
	#$map/tent3/info/image.texture = ""
	game3_location = "scenes/pattern.tscn"
	
	# game 4
	#$map/tent4.visible = 0
	#$map/tent4/info/title.text = "Game Title"
	#$map/tent4/info/info2.text = "Small desribtion."
	#$map/tent4/info/info3.text = "Highest score/etc"
	##$map/tent4/info/image.texture = ""
	#game4_location = ""
	#

func allow_move():
	$player.move = 1
func disable_move():
	$player.move = 0
	

func _ready() -> void:
	allow_move()
	assign_games_data()
	$CanvasLayer/black.visible = 1
	$CanvasLayer/frame.visible = 1
	#final_game()
	if global.patterns_won && global.wac_highest >= 20 && global.shooter_highest >= 20 && !global.ghost_defeated:
		final_game()

var ghost_fight = 0

var tent2 = 0
var tent3 = 0
var tent4 = 0


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Interact"):
		if tent_shooter:
			await enter_game("res://scenes/shooter.tscn")
		if tent2:
			await enter_game(game2_location)
		if tent3:
			await enter_game(game3_location)
		if tent4:
			await enter_game(game4_location)
	if Input.is_action_just_pressed("jump") && hit_bar:
		#print("jump")
		if $CanvasLayer/hit_bar/dash.position.x < 691 && $CanvasLayer/hit_bar/dash.position.x > 653:
			print("correct")
			hit_bar -= 1
			if !hit_bar:
				hit_tween.kill()
				phase += 1
				final_game()
		else:
			ghost_attack()

	$map/shooter_tent/info.position.x = remap($player.position.x, 320, 800, 90, -130)
	$map/tent2/info.position.x = remap($player.position.x, 320, 800, 90, -130)
	
	#print($player.position)

func enter_game(game):
	disable_move()
	var tween = create_tween()
	tween.tween_property($CanvasLayer/black, "modulate:a", 1, 0.3)
	
	await get_tree().create_timer(0.3).timeout
	
	get_tree().change_scene_to_file(game)


var tent_shooter = 0
var pulse: Tween
var pulse2: Tween
var pulse3: Tween

#############################################
#					Tent 1					#
#############################################

func _on_tent_shooter_body_entered(body: Node2D) -> void:
	if body.name == "player":
		print("tent")
		tent_shooter = 1
		var e = $map/shooter_tent/e
		var og_scale = e.scale.x
		var tw_scale = e.scale.x + 0.04
		e.visible = 1
		
		pulse = create_tween().set_loops()
		pulse.tween_property(e, "scale", Vector2(tw_scale, tw_scale), 0.3)
		pulse.tween_property(e, "scale", Vector2(og_scale, og_scale), 0.3)

func _on_tent_shooter_body_exited(body: Node2D) -> void:
	if body.name == "player":
		tent_shooter = 0
		$map/shooter_tent/e.visible = 0 
		if pulse:
			pulse.kill()
		$map/shooter_tent/e.scale = Vector2(0.195, 0.195)

func _on_tent1_info_area_body_entered(body: Node2D) -> void:
	if body.name == "player":
		#var tween_frame = create_tween()
		#tween_frame.tween_property($CanvasLayer/frame, "modulate:a", 1, 0.3)
		
		
		var tent = $map/shooter_tent/tent
		var tent_up = $map/shooter_tent/tent_up
		var og_scale = tent.scale.x
		var tw_scale = tent.scale.x + 0.002
		
		pulse2 = create_tween().set_loops()
		pulse3 = create_tween().set_loops()
		
		pulse2.tween_property(tent, "scale", Vector2(tw_scale, tw_scale), 0.3)
		pulse2.tween_property(tent, "scale", Vector2(og_scale, og_scale), 0.3)
		
		pulse3.tween_property(tent_up, "scale", Vector2(tw_scale, tw_scale), 0.3)
		pulse3.tween_property(tent_up, "scale", Vector2(og_scale, og_scale), 0.3)
		
		
		var info = $map/shooter_tent/info
		info.visible = 1
		info.scale = Vector2(0,0)
		var tween = create_tween()
		tween.tween_property(info, "scale", Vector2(1.1,1.1), 0.3)
		tween.tween_property(info, "scale", Vector2(1,1), 0.1)
func _on_tent1_info_area_body_exited(body: Node2D) -> void:
	if body.name == "player":
		var tween_frame = create_tween()
		tween_frame.tween_property($CanvasLayer/frame, "modulate:a", 0, 0.3)
		
		
		$map/shooter_tent/tent.scale = Vector2(0.184, 0.184)
		$map/shooter_tent/tent_up.scale = Vector2(0.184, 0.184)
		pulse2.kill()
		pulse3.kill()
		
		var info = $map/shooter_tent/info
		var tween = create_tween()
		tween.tween_property(info, "scale", Vector2(1.1,1.1), 0.3)
		tween.tween_property(info, "scale", Vector2(0,0), 0.1)
		#info.visible = 0

#############################################
#					Tent 2					#
#############################################

func _on_tent2_body_entered(body: Node2D) -> void:
	if body.name == "player":
		if !$map/tent2.visible: return
		print("tent")
		tent2 = 1
		var e = $map/tent2/e
		var og_scale = e.scale.x
		var tw_scale = e.scale.x + 0.04
		e.visible = 1
		
		pulse = create_tween().set_loops()
		pulse.tween_property(e, "scale", Vector2(tw_scale, tw_scale), 0.3)
		pulse.tween_property(e, "scale", Vector2(og_scale, og_scale), 0.3)

func _on_tent2_body_exited(body: Node2D) -> void:
	if body.name == "player":
		if !$map/tent2.visible: return
		tent2 = 0
		$map/tent2/e.visible = 0 
		if pulse:
			pulse.kill()
		$map/tent2/e.scale = Vector2(0.195, 0.195)

func _on_tent2_info_area_body_entered(body: Node2D) -> void:
	if body.name == "player":
		if !$map/tent2.visible: return
		var tween_frame = create_tween()
		tween_frame.tween_property($CanvasLayer/frame, "modulate:a", 1, 0.3)
		
		var tent = $map/tent2/tent
		var tent_up = $map/tent2/tent_up
		var og_scale = tent.scale.x
		var tw_scale = tent.scale.x + 0.002
		
		pulse2 = create_tween().set_loops()
		pulse3 = create_tween().set_loops()
		
		pulse2.tween_property(tent, "scale", Vector2(tw_scale, tw_scale), 0.3)
		pulse2.tween_property(tent, "scale", Vector2(og_scale, og_scale), 0.3)
		
		pulse3.tween_property(tent_up, "scale", Vector2(tw_scale, tw_scale), 0.3)
		pulse3.tween_property(tent_up, "scale", Vector2(og_scale, og_scale), 0.3)
		
		var info = $map/tent2/info
		info.visible = 1
		info.scale = Vector2(0,0)
		var tween = create_tween()
		tween.tween_property(info, "scale", Vector2(1.1,1.1), 0.3)
		tween.tween_property(info, "scale", Vector2(1,1), 0.1)
func _on_tent2_info_area_body_exited(body: Node2D) -> void:
	if body.name == "player":
		if !$map/tent2.visible: return
		var tween_frame = create_tween()
		tween_frame.tween_property($CanvasLayer/frame, "modulate:a", 0, 0.3)
		
		$map/tent2/tent.scale = Vector2(0.184, 0.184)
		$map/tent2/tent_up.scale = Vector2(0.184, 0.184)
		pulse2.kill()
		pulse3.kill()
		
		var info = $map/tent2/info
		var tween = create_tween()
		tween.tween_property(info, "scale", Vector2(1.1,1.1), 0.3)
		tween.tween_property(info, "scale", Vector2(0,0), 0.1)
		#info.visible = 0


#############################################
#					Tent 3					#
#############################################


func _on_tent3_body_entered(body: Node2D) -> void:
	if body.name == "player":
		if !$map/tent3.visible: return
		print("tent")
		tent3 = 1
		var e = $map/tent3/e
		var og_scale = e.scale.x
		var tw_scale = e.scale.x + 0.04
		e.visible = 1
		
		pulse = create_tween().set_loops()
		pulse.tween_property(e, "scale", Vector2(tw_scale, tw_scale), 0.3)
		pulse.tween_property(e, "scale", Vector2(og_scale, og_scale), 0.3)

func _on_tent3_body_exited(body: Node2D) -> void:
	if body.name == "player":
		if !$map/tent3.visible: return
		tent3 = 0
		$map/tent3/e.visible = 0 
		if pulse:
			pulse.kill()
		$map/tent3/e.scale = Vector2(0.195, 0.195)

func _on_tent3_info_area_body_entered(body: Node2D) -> void:
	if body.name == "player":
		if !$map/tent3.visible: return
		var tween_frame = create_tween()
		tween_frame.tween_property($CanvasLayer/frame, "modulate:a", 1, 0.3)
		
		var tent = $map/tent3/tent
		var tent_up = $map/tent3/tent_up
		var og_scale = tent.scale.x
		var tw_scale = tent.scale.x + 0.002
		
		pulse2 = create_tween().set_loops()
		pulse3 = create_tween().set_loops()
		
		pulse2.tween_property(tent, "scale", Vector2(tw_scale, tw_scale), 0.3)
		pulse2.tween_property(tent, "scale", Vector2(og_scale, og_scale), 0.3)
		
		pulse3.tween_property(tent_up, "scale", Vector2(tw_scale, tw_scale), 0.3)
		pulse3.tween_property(tent_up, "scale", Vector2(og_scale, og_scale), 0.3)
		
		var info = $map/tent3/info
		info.visible = 1
		info.scale = Vector2(0,0)
		var tween = create_tween()
		tween.tween_property(info, "scale", Vector2(1.1,1.1), 0.3)
		tween.tween_property(info, "scale", Vector2(1,1), 0.1)
func _on_tent3_info_area_body_exited(body: Node2D) -> void:
	if body.name == "player":
		if !$map/tent3.visible: return
		var tween_frame = create_tween()
		tween_frame.tween_property($CanvasLayer/frame, "modulate:a", 0, 0.3)
		
		$map/tent3/tent.scale = Vector2(0.184, 0.184)
		$map/tent3/tent_up.scale = Vector2(0.184, 0.184)
		pulse2.kill()
		pulse3.kill()
		
		var info = $map/tent3/info
		var tween = create_tween()
		tween.tween_property(info, "scale", Vector2(1.1,1.1), 0.3)
		tween.tween_property(info, "scale", Vector2(0,0), 0.1)
		

#############################################
#					Tent 4					#
#############################################


func _on_tent4_body_entered(body: Node2D) -> void:
	if body.name == "player":
		if !$map/tent4.visible: return
		print("tent")
		tent4 = 1
		var e = $map/tent4/e
		var og_scale = e.scale.x
		var tw_scale = e.scale.x + 0.04
		e.visible = 1
		
		pulse = create_tween().set_loops()
		pulse.tween_property(e, "scale", Vector2(tw_scale, tw_scale), 0.3)
		pulse.tween_property(e, "scale", Vector2(og_scale, og_scale), 0.3)

func _on_tent4_body_exited(body: Node2D) -> void:
	if body.name == "player":
		if !$map/tent4.visible: return
		tent4 = 0
		$map/tent4/e.visible = 0 
		if pulse:
			pulse.kill()
		$map/tent4/e.scale = Vector2(0.195, 0.195)

func _on_tent4_info_area_body_entered(body: Node2D) -> void:
	if body.name == "player":
		if !$map/tent4.visible: return
		var tween_frame = create_tween()
		tween_frame.tween_property($CanvasLayer/frame, "modulate:a", 1, 0.3)
		
		var tent = $map/tent4/tent
		var tent_up = $map/tent4/tent_up
		var og_scale = tent.scale.x
		var tw_scale = tent.scale.x + 0.002
		
		pulse2 = create_tween().set_loops()
		pulse3 = create_tween().set_loops()
		
		pulse2.tween_property(tent, "scale", Vector2(tw_scale, tw_scale), 0.3)
		pulse2.tween_property(tent, "scale", Vector2(og_scale, og_scale), 0.3)
		
		pulse3.tween_property(tent_up, "scale", Vector2(tw_scale, tw_scale), 0.3)
		pulse3.tween_property(tent_up, "scale", Vector2(og_scale, og_scale), 0.3)
		
		var info = $map/tent4/info
		info.visible = 1
		info.scale = Vector2(0,0)
		var tween = create_tween()
		tween.tween_property(info, "scale", Vector2(1.1,1.1), 0.3)
		tween.tween_property(info, "scale", Vector2(1,1), 0.1)
func _on_tent4_info_area_body_exited(body: Node2D) -> void:
	if body.name == "player":
		if !$map/tent4.visible: return
		var tween_frame = create_tween()
		tween_frame.tween_property($CanvasLayer/frame, "modulate:a", 0, 0.3)
		
		$map/tent4/tent.scale = Vector2(0.184, 0.184)
		$map/tent4/tent_up.scale = Vector2(0.184, 0.184)
		pulse2.kill()
		pulse3.kill()
		
		var info = $map/tent4/info
		var tween = create_tween()
		tween.tween_property(info, "scale", Vector2(1.1,1.1), 0.3)
		tween.tween_property(info, "scale", Vector2(0,0), 0.1)

var hit_bar = 0
var hit_tween
func final_game():
	ghost_fight = 1
	disable_move()
	$CanvasLayer/health.visible = 1
	health = 3
	$player/Camera2D.position = Vector2(154, -86)
	$player.position = Vector2(-298, -223)
	$map/Panel.visible = 1
	
	match phase:
		1: finale_phase1()
		2: finale_phase2()
		3: finale_phase3()

func finale_phase1():
	$CanvasLayer/hit_bar.visible = 1
	hit_bar = 3
	hit_tween = create_tween().set_loops()
	hit_tween.tween_property($CanvasLayer/hit_bar/dash, "position:x", 510.0, 1.5)
	hit_tween.tween_property($CanvasLayer/hit_bar/dash, "position:x", 776.0, 1.5)

func finale_phase2():
	auto_light()

var health = 3
func ghost_attack():
	print("health--")
	$CanvasLayer/health.get_child(health-1).get_child(0).visible = 0
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
	
	allow_move()
	$map/Panel.visible = 0
	$player/Camera2D.position = Vector2(0, -86)
	$player.position = Vector2(-298, -223)
	ghost_fight = 0
	$CanvasLayer/dark.visible = 0
	
