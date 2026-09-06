extends Area2D

@export var polarity=1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
	#program a destruct 
	if("polarity" in body && body.has_method("Destruct")):
		if(body.polarity != polarity):
			body.Destruct()
