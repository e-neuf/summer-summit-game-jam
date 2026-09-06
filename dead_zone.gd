extends Area2D
#@onready var GameOver =preload("res://levels/Game_Over.tscn") as PackedScene


func _on_body_entered(body: CharacterBody2D) -> void:
	#sound effect of death
	#await get_tree.create_timer(0.3).timeout #timer while sound plays
	if(body is MainCharacter):
		print("Deadddd")
		#get_tree().change_scene_to_packed(GameOver)
		Global.Level.restart_level()
