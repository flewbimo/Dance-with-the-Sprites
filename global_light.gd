extends Node2D

var lights :Array[Dictionary]= [
		{
			"pos" : Vector2(0, 0),
			"range" : 10.0,
			"col" : Color.IVORY,
			"ang" : PI,
			"fan_ang" : PI
		},
	]
var releasedlights:Array[int] =[]


