extends Area2D
@onready var GameOver =preload("res://levels/Game_Over.tscn") as PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Dead zone ready")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass





func _on_body_entered(body: CharacterBody2D) -> void:
	#sound effect of death
	#await get_tree.create_timer(0.3).timeout #timer while sound plays
	print("Deadddd")
	get_tree().change_scene_to_packed(GameOver)
