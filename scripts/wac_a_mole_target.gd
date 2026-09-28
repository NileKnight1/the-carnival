extends Node2D

var game
var id
var template = 1

func check_click(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and !template:
		return 1

func _ready() -> void:
	scale = Vector2(0, 0)
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.1,1.1), 0.3)
	tween.tween_property(self, "scale", Vector2(1,1), 0.1) 
	 
var falling = 0
func _process(delta: float) -> void:
	if falling:
		$skins.position.y += 5

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if check_click(event):
		game.target_hit()
		#game.handeled = 1
		#game.current_targets -= 1
		#game.targets_list[id] = 0
		$Area2D/CollisionShape2D.set_deferred("disabled", 1)
		$hit.visible = 1
		await get_tree().create_timer(0.05).timeout
		$hit.visible = 0
		falling = 1
		$skins.rotation = deg_to_rad(randi_range(-45, 45))
		
		$Label.visible = 1
		await get_tree().create_timer(1).timeout
		var tween = create_tween()
		tween.tween_property(self, "modulate:a", 0, 0.2)
		await get_tree().create_timer(0.3).timeout
		
		queue_free()
