extends ColorRect

const START_COLOR := Color(0.06, 0.05, 0.06)
const GOAL_COLOR := Color(0.23, 0.16, 0.09) # warm gold


func _ready() -> void:
	color = START_COLOR
	#once there's an actual multi-screen level to progress through, just add colors to shift according to the mood
