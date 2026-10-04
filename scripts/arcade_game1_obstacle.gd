extends Area2D

var game

func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		print("kill")
		game.arcade_game1_death()
