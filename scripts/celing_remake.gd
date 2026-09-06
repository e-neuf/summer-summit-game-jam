extends Area2D


func _on_body_entered(body: CharacterBody2D) -> void:
	if(body is MainCharacter):
		var bod_pos=body.global_position
		body.global_position=Vector2(bod_pos.x, bod_pos.y+300)
