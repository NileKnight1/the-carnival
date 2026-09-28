extends Node2D

var game2_location
var game3_location
var game4_location

# الي يضيف لعبة يعدل هنا بس
func assign_games_data():
	# game 2
	$map/tent2.visible = 0
	$map/tent2/info/title.text = ""
	$map/tent2/info/info2.text = ""
	$map/tent2/info/info3.text = ""
	#$map/tent2/info/image.texture = ""
	game2_location = ""
	
	# game 3
	$map/tent3.visible = 0
	$map/tent3/info/title.text = "Game Title"
	$map/tent3/info/info2.text = "Small desribtion."
	$map/tent3/info/info3.text = "Highest score/etc"
	#$map/tent3/info/image.texture = ""
	game3_location = ""
	
	# game 4
	$map/tent4.visible = 0
	$map/tent4/info/title.text = "Game Title"
	$map/tent4/info/info2.text = "Small desribtion."
	$map/tent4/info/info3.text = "Highest score/etc"
	#$map/tent4/info/image.texture = ""
	game4_location = ""
	

func allow_move():
	$player.move = 1
func disable_move():
	$player.move = 0
	

func _ready() -> void:
	allow_move()
	assign_games_data()
	$CanvasLayer/black.visible = 1
	$CanvasLayer/frame.visible = 1

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
		var tween_frame = create_tween()
		tween_frame.tween_property($CanvasLayer/frame, "modulate:a", 1, 0.3)
		
		
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
		
