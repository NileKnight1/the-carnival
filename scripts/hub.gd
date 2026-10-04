extends Node2D

var game1_location
var game2_location
var game3_location
var game4_location
var gamex_location

# الي يضيف لعبة يعدل هنا بس
func assign_games_data():
	# game 1
	$map/tent1.visible = 1
	$map/tent1/info/title.text = ""
	$map/tent1/info/info2.text = ""
	$map/tent1/info/info3.text = ""
	#$map/tent1/info/image.texture = ""
	game1_location = "scenes/shooter.tscn"
	
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
	
	
	# game x
	$map/tentx.visible = 1
	$map/tentx/info/title.text = "Game Title"
	$map/tentx/info/info2.text = "Small desribtion."
	$map/tentx/info/info3.text = "Highest score/etc"
	#$map/tent3/info/image.texture = ""
	gamex_location = "scenes/pattern.tscn"
	

func allow_move():
	$player.move = 1
func disable_move():
	$player.move = 0
	

#
#var shooter_highest = 0
#var wac_highest = 0
#var patterns_won = 0
#var ghost_defeated = 0
#
#var shooters_prize = 0
#var wac_prize = 0
#var patterns_prize = 0
#


func _ready() -> void:
	
	var key = $CanvasLayer/rewards/key
	var add_heart = $CanvasLayer/rewards/heart
	var plushie = $CanvasLayer/rewards/plushie
	
	key.modulate.a = 0
	
	if global.chat1_done:
		$map/stranger.visible = 0
	
	$CanvasLayer/subtitles.visible = 0
	$CanvasLayer/subtitles/subtitle.text = ""
	
	if global.shooter_highest > 20 && !global.shooters_prize:
	#if 1:
		disable_move()
		await get_tree().create_timer(0.6).timeout
		global.shooters_prize = 1
		key.visible = 1
		var temp = key.position.y
		key.position.y -= 50
		var tween = create_tween().set_parallel(true)
		tween.tween_property(key, "position:y", key.position.y+50, 0.6)
		tween.tween_property(key, "modulate:a", 1, 0.6)
		allow_move()
		
		await get_tree().create_timer(3.0).timeout
		tween = create_tween().set_parallel(true)
		tween.tween_property(key, "position:y", key.position.y-50, 1)
		tween.tween_property(key, "modulate:a", 0, 1)
	
	if global.wac_highest > 20 && !global.wac_prize:
	#if 1:
		global.health += 1
		disable_move()
		global.wac_prize = 1
		await get_tree().create_timer(0.6).timeout
		add_heart.visible = 1
		var temp = add_heart.position.y
		add_heart.position.y -= 50
		var tween = create_tween().set_parallel(true)
		tween.tween_property(add_heart, "position:y", add_heart.position.y+50, 0.6)
		tween.tween_property(add_heart, "modulate:a", 1, 0.6)
		allow_move()
		
		await get_tree().create_timer(3.0).timeout
		tween = create_tween().set_parallel(true)
		tween.tween_property(add_heart, "position:y", add_heart.position.y-50, 1)
		tween.tween_property(add_heart, "modulate:a", 0, 1)
	
	if global.patterns_won > 20 && !global.patterns_prize:
	#if 1:
		disable_move()
		await get_tree().create_timer(0.6).timeout
		global.patterns_prize = 1
		plushie.visible = 1
		var temp = plushie.position.y
		plushie.position.y -= 50
		var tween = create_tween().set_parallel(true)
		tween.tween_property(plushie, "position:y", plushie.position.y+50, 0.6)
		tween.tween_property(plushie, "modulate:a", 1, 0.6)
		allow_move()
		
		await get_tree().create_timer(3.0).timeout
		tween = create_tween().set_parallel(true)
		tween.tween_property(plushie, "position:y", plushie.position.y-50, 1)
		tween.tween_property(plushie, "modulate:a", 0, 1)
	
	allow_move()
	assign_games_data()
	$CanvasLayer/black.visible = 1
	$CanvasLayer/frame.visible = 1
	#final_game()
	#if global.patterns_won && global.wac_highest >= 20 && global.shooter_highest >= 20 && !global.ghost_defeated:
		#final_game()

var ghost_fight = 0

var tent2 = 0
var tent3 = 0
var tent4 = 0


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Interact") && global.can_play:
		if tent_shooter:
			await enter_game("res://scenes/shooter.tscn")
		if tent2:
			await enter_game(game2_location)
		if tent3:
			await enter_game(game3_location)
		if tent4:
			await enter_game(game4_location)
	if Input.is_action_just_pressed("Interact") && chatting:
		show_chat(cur_chat)
	
	temp_func()
	

	$map/tent1/info.position.x = remap($player.position.x, 320, 800, 90, -130)
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
	if body.name == "player" && global.can_play:
		print("tent")
		tent_shooter = 1
		var e = $map/tent1/e
		var og_scale = e.scale.x
		var tw_scale = e.scale.x + 0.04
		e.visible = 1
		
		pulse = create_tween().set_loops()
		pulse.tween_property(e, "scale", Vector2(tw_scale, tw_scale), 0.3)
		pulse.tween_property(e, "scale", Vector2(og_scale, og_scale), 0.3)

func _on_tent_shooter_body_exited(body: Node2D) -> void:
	if body.name == "player":
		tent_shooter = 0
		$map/tent1/e.visible = 0 
		if pulse:
			pulse.kill()
		$map/tent1/e.scale = Vector2(0.195, 0.195)

func _on_tent1_info_area_body_entered(body: Node2D) -> void:
	if body.name == "player" && global.can_play:
		#var tween_frame = create_tween()
		#tween_frame.tween_property($CanvasLayer/frame, "modulate:a", 1, 0.3)
		
		
		var tent = $map/tent1/tent
		var tent_up = $map/tent1/tent_up
		var og_scale = tent.scale.x
		var tw_scale = tent.scale.x + 0.002
		
		pulse2 = create_tween().set_loops()
		pulse3 = create_tween().set_loops()
		
		pulse2.tween_property(tent, "scale", Vector2(tw_scale, tw_scale), 0.3)
		pulse2.tween_property(tent, "scale", Vector2(og_scale, og_scale), 0.3)
		
		pulse3.tween_property(tent_up, "scale", Vector2(tw_scale, tw_scale), 0.3)
		pulse3.tween_property(tent_up, "scale", Vector2(og_scale, og_scale), 0.3)
		
		
		var info = $map/tent1/info
		info.visible = 1
		info.scale = Vector2(0,0)
		var tween = create_tween()
		tween.tween_property(info, "scale", Vector2(1.1,1.1), 0.3)
		tween.tween_property(info, "scale", Vector2(1,1), 0.1)
func _on_tent1_info_area_body_exited(body: Node2D) -> void:
	if body.name == "player" :
		var tween_frame = create_tween()
		tween_frame.tween_property($CanvasLayer/frame, "modulate:a", 0, 0.3)
		
		
		$map/tent1/tent.scale = Vector2(0.184, 0.184)
		$map/tent1/tent_up.scale = Vector2(0.184, 0.184)
		if pulse2: pulse2.kill()
		if pulse3: pulse3.kill()
		
		var info = $map/tent1/info
		var tween = create_tween()
		tween.tween_property(info, "scale", Vector2(1.1,1.1), 0.3)
		tween.tween_property(info, "scale", Vector2(0,0), 0.1)
		#info.visible = 0

#############################################
#					Tent 2					#
#############################################

func _on_tent2_body_entered(body: Node2D) -> void:
	if body.name == "player" && global.can_play:
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
	if body.name == "player" && global.can_play:
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
		if pulse2: pulse2.kill()
		if pulse3: pulse3.kill()
		
		var info = $map/tent2/info
		var tween = create_tween()
		tween.tween_property(info, "scale", Vector2(1.1,1.1), 0.3)
		tween.tween_property(info, "scale", Vector2(0,0), 0.1)
		#info.visible = 0


#############################################
#					Tent 3					#
#############################################


func _on_tent3_body_entered(body: Node2D) -> void:
	if body.name == "player" && global.can_play:
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
	if body.name == "player" && global.can_play:
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
		if pulse2: pulse2.kill()
		if pulse3: pulse3.kill()
		
		var info = $map/tent3/info
		var tween = create_tween()
		tween.tween_property(info, "scale", Vector2(1.1,1.1), 0.3)
		tween.tween_property(info, "scale", Vector2(0,0), 0.1)
		

#############################################
#					Tent 4					#
#############################################


func _on_tent4_body_entered(body: Node2D) -> void:
	if body.name == "player" && global.can_play:
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
	if body.name == "player" && global.can_play:
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
		if pulse2: pulse2.kill()
		if pulse3: pulse3.kill()
		
		var info = $map/tent4/info
		var tween = create_tween()
		tween.tween_property(info, "scale", Vector2(1.1,1.1), 0.3)
		tween.tween_property(info, "scale", Vector2(0,0), 0.1)


#############################################
#					Tent X					#
#############################################

var tentx = 0

func _on_tentx_body_entered(body: Node2D) -> void:
	if body.name == "player" && global.can_play:
		if !$map/tentx.visible: return
		print("tent")
		tentx = 1
		var e = $map/tentx/e
		var og_scale = e.scale.x
		var tw_scale = e.scale.x + 0.04
		e.visible = 1
		
		pulse = create_tween().set_loops()
		pulse.tween_property(e, "scale", Vector2(tw_scale, tw_scale), 0.3)
		pulse.tween_property(e, "scale", Vector2(og_scale, og_scale), 0.3)

func _on_tentx_body_exited(body: Node2D) -> void:
	if body.name == "player":
		if !$map/tentx.visible: return
		tentx = 0
		$map/tentx/e.visible = 0 
		if pulse:
			pulse.kill()
		$map/tentx/e.scale = Vector2(0.195, 0.195)

func _on_tentx_info_area_body_entered(body: Node2D) -> void:
	if body.name == "player" && global.can_play:
		if !$map/tentx.visible: return
		var tween_frame = create_tween()
		tween_frame.tween_property($CanvasLayer/frame, "modulate:a", 1, 0.3)
		
		var tent = $map/tentx/tent
		var tent_up = $map/tentx/tent_up
		var og_scale = tent.scale.x
		var tw_scale = tent.scale.x + 0.002
		
		pulse2 = create_tween().set_loops()
		pulse3 = create_tween().set_loops()
		
		pulse2.tween_property(tent, "scale", Vector2(tw_scale, tw_scale), 0.3)
		pulse2.tween_property(tent, "scale", Vector2(og_scale, og_scale), 0.3)
		
		pulse3.tween_property(tent_up, "scale", Vector2(tw_scale, tw_scale), 0.3)
		pulse3.tween_property(tent_up, "scale", Vector2(og_scale, og_scale), 0.3)
		
		var info = $map/tentx/info
		info.visible = 1
		info.scale = Vector2(0,0)
		var tween = create_tween()
		tween.tween_property(info, "scale", Vector2(1.1,1.1), 0.3)
		tween.tween_property(info, "scale", Vector2(1,1), 0.1)
func _on_tentx_info_area_body_exited(body: Node2D) -> void:
	if body.name == "player":
		if !$map/tentx.visible: return
		var tween_frame = create_tween()
		tween_frame.tween_property($CanvasLayer/frame, "modulate:a", 0, 0.3)
		
		$map/tentx/tent.scale = Vector2(0.184, 0.184)
		$map/tentx/tent_up.scale = Vector2(0.184, 0.184)
		if pulse2: pulse2.kill()
		if pulse3: pulse3.kill()
		
		var info = $map/tentx/info
		var tween = create_tween()
		tween.tween_property(info, "scale", Vector2(1.1,1.1), 0.3)
		tween.tween_property(info, "scale", Vector2(0,0), 0.1)

func _on_stranger_left_body_entered(body: Node2D) -> void:
	if body == $player:
		print("x")
		if !global.chat1_done:
			stranger_chat1()
			global.can_play = 1
			global.chat1_done = 1

func _on_stranger_left_body_exited(body: Node2D) -> void:
	if body == $player:
		#print("xx")
		#var tween = create_tween()
		#tween.tween_property($map/Panel2, "position:y", )
		$map/stranger.visible = 0

func _on_stranger_right_body_entered(body: Node2D) -> void:
	if body == $player:
		if !global.chat1_done:
			stranger_chat1()
			global.chat1_done = 1
func _on_stranger_right_body_exited(body: Node2D) -> void:
	if body == $player:
		$map/stranger.visible = 0


var chat1 = [
		"You've made a big mistake coming here.",
		"No one can escape this place, The Ghost doesn't allow this, unless you beat his games.",
		"That's the only way to escape.",
	]

func stranger_chat1():
	disable_move()
	chatting = 1
	show_chat(chat1)


var chat_i = 0
var chatting = 0
var cur_chat

var chat_tween

var chat1_done

func show_chat(chat):
	var sub = $CanvasLayer/subtitles/subtitle
	if chat_i == chat.size():
		chatting = 0
		chat_i = 0
		sub.text = ""
		$CanvasLayer/subtitles.visible = 0
		allow_move()
		return
	
	$CanvasLayer/subtitles.visible = 1
	cur_chat = chat
	sub.text = chat[chat_i]
	#var str = "sdasdasdasd"
	#print(str.length())
	if chat_tween: chat_tween.kill()
	sub.visible_ratio = 0
	chat_tween = create_tween()
	chat_tween.tween_property(sub, "visible_ratio", 1.0, chat[chat_i].length()/15)
	
	chat_i += 1


var wheel_area = 0
func _on_wheel_area_body_entered(body: Node2D) -> void:
	if body == $player:
		wheel_area = 1
func _on_wheel_area_body_exited(body: Node2D) -> void:
	if body == $player:
		wheel_area = 0



func _on_spin_wheel_pressed() -> void:
	var temp = randi_range(3600, 3960)
	print(temp)
	#temp *= 10
	var tween = create_tween()
	tween.tween_property($map/wheel/spin, "rotation_degrees", temp, 4).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT).from(0)
	await get_tree().create_timer(5).timeout
	print(temp)
	#temp /= 10
	if temp < 3645:
		print(1)
	elif temp <= 3690:
		print(8)
	elif temp <= 3735:
		print(7)
	elif temp <= 3780:
		print(6)
	elif temp <= 3825:
		print(5)
	elif temp <= 3870:
		print(4)
	elif temp <= 3915:
		print(3)
	elif temp <= 3960:
		print(2)

func arcade_game1_run():
	arcade1_score = 0
	$map/arcade_device1/screen/highest.text = "Highest: " + str(global.arcade1_highest)
	$map/arcade_device1/screen/score.text = "Score: " + str(arcade1_score) 
	
	$map/arcade_device1/screen/aracde1_restart.visible = 0
	for i in $map/arcade_device1/screen/obstacles.get_children():
		i.queue_free()
	arcade_game1_running = 1
	$map/arcade_device1/screen/player.move = 1
	arcade_game1_spawn()
	arcade_game1_timer()
	

var arcade_device1_area = 0
func _on_arcade_device_1_area_body_entered(body: Node2D) -> void:
	if body == $player:
		arcade_device1_area = 1
func _on_arcade_device_1_area_body_exited(body: Node2D) -> void:
	if body == $player:
		arcade_device1_area = 0

var arcade1_score = 0

func arcade_game1_timer():
	if !arcade_game1_running: return
	await get_tree().create_timer(0.001).timeout
	#print($map/arcade_device1/screen/obstacles.get_child_count())
	for i in $map/arcade_device1/screen/obstacles.get_children():
		#print(i)
		#print(i.position.x)
		i.position.x -= 0.3 + (arcade1_score * 0.01)
		if i.position.x < 0:
			i.queue_free()
			arcade_game1_spawn()
			arcade1_score += 1
			global.arcade1_highest = max(global.arcade1_highest,arcade1_score)
			$map/arcade_device1/screen/highest.text = "Highest: " + str(global.arcade1_highest)
			$map/arcade_device1/screen/score.text = "Score: " + str(arcade1_score) 
			
			 
	arcade_game1_timer()

func arcade_game1_spawn():
	#print('spawn')
	var temp = $map/arcade_device1/screen/ref.duplicate()
	temp.visible = 1
	temp.position = Vector2(46.0, 28.0)
	temp.get_child(0).game = self
	$map/arcade_device1/screen/obstacles.add_child(temp)
	#print($map/arcade_device1/screen/obstacles)

var arcade_game1_running = 0
func arcade_game1_death():
	print("x")
	arcade_game1_running = 0
	$map/arcade_device1/screen/player.move = 0
	$map/arcade_device1/screen/aracde1_restart.visible = 1


func _on_aracde_1_restart_pressed() -> void:
	arcade_game1_run()

var photo_booth_area = 0
func _on_photo_booth_area_body_entered(body: Node2D) -> void:
	if body == $player:
		photo_booth_area = 1
		print('x')
func _on_photo_booth_area_body_exited(body: Node2D) -> void:
	if body == $player:
		photo_booth_area = 0


func temp_func():
	if Input.is_action_just_pressed("Interact"):
		if wheel_area:
			if $player.move:
				disable_move()
				$player.visible = 0
				$player/camera.enabled = 0
				$map/wheel/camera.enabled = 1
			else:
				allow_move()
				$player.visible = 1
				$player/camera.enabled = 1
				$map/wheel/camera.enabled = 0
		
		if arcade_device1_area:
			if $player.move:
				arcade_game1_run()
				disable_move()
				$player.visible = 0
				$player/camera.enabled = 0
				$map/arcade_device1/camera.enabled = 1
			else:
				arcade_game1_running = 0
				$map/arcade_device1/screen/player.move = 0
				allow_move()
				$player.visible = 1
				$player/camera.enabled = 1
				$map/arcade_device1/camera.enabled = 0
		
		if photo_booth_area:
			print("hre")
			if $player.move:
				$player.gravity = 0
				disable_move()
				$player/camera.enabled = 0
				$map/photo_booth/camera.enabled = 1
				var tween = create_tween()
				tween.tween_property($map/photo_booth/curtain, "size:x", 50, 1).from(268)
				#await get_tree().create_timer(0.8).timeout
				$player.position = Vector2(1276.0, 1425.0)
				$map/photo_booth/curtain.z_index = 1
			else:
				$player.gravity = 1
				allow_move()
				var tween = create_tween()
				tween.tween_property($map/photo_booth/curtain, "size:x", 268, 1).from(50)
				$map/photo_booth/curtain.z_index = 0
				
				$player.visible = 1
				$player/camera.enabled = 1
				$map/photo_booth/camera.enabled = 0
				
		
