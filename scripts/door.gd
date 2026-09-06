extends Node2D


func _on_body_entered(body: Node2D) -> void:
	if body == Global.Main_character:
		print("It is the circle!!!")
		Global.Level.game_over()
