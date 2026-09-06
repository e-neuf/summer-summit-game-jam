extends Area2D

@export var polarity=1


func _on_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
	#program a destruct in enemy and in the player
	if("polarity" in body && body.has_method("Destruct")):
		if(body.polarity != polarity):
			body.Destruct()
