extends Node
##STORES VARIABLES ALL ENTITES CAN ACCESS
##FOR EASE OF IDK VARIABLE SHARING CUZ I BECAME STUPID

signal Level_Registered()
signal Player_Registered()

var Level = null
var MC_magnets_in_range: Array = []
var Main_character = null
var Current_Attraction = null
var Gravity = 12
