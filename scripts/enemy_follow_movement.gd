class_name FollowMovementC extends Node
@export var speed=20 
@onready var parent: CharacterBody2D=get_parent()
var start_pos
var target: MainCharacter
# Called when the node enters the scene tree for the first time.
func _ready():
	start_pos=parent.postion

func update_velocity():
	pass
	#program in a way such that it cannot jump? we can make two different versions i think

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	update_velocity();
	parent.move_and_slide()
func _disable()->void:
	process_mode=ProcessMode.PROCESS_MODE_DISABLED


func _on_sense_player_body_entered(body: Node2D) -> void:
	if body is MainCharacter:
		target=body
		print("dont touch me body body ")
		


func _on_sense_player_body_exited(body: Node2D) -> void:
	target=null
