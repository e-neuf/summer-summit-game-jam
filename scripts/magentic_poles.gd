extends Area2D

var sign= 1 #1 is postive, 0 is negative
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
	#check postioning and sign of main character
	#figure out positon of character, and set up the buttons
	#if sign is equal to the sign of the pole, make the player move away
	#otherwise, make the player move towards
