extends PathFollow2D

enum State{
	friend,
	enemyslow,
	enemyfast,
	boss
}
#var speed =0.02
#enum Action{
	#stop,
	#updown,
	#leftright
#}
var isrunafter:bool = false
var direction:Vector2
@export var state:State = State.friend
#var action:Action = Action.stop
var index:int =0
@export var range:float = 10.0
@export var color:Color = Color.ORANGE
@export var ang:float = PI
@export var fan_ang:float = PI
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if state ==0:
		color = get_random_color_excluding_red()
	progress = randf_range(0,10000)
	# 创建一个新的字典
	var new_light = {
		"pos": position,
		"range": range,
		"col": color,
		"ang": ang ,
		"fan_ang": fan_ang
	}

# 将新的字典添加到 lights 数组
	if GlobalLight.releasedlights.is_empty():
		GlobalLight.lights.append(new_light)
		index = GlobalLight.lights.size()-1
	else:
		index=GlobalLight.releasedlights[0]
		GlobalLight.releasedlights.remove_at(0)
		GlobalLight.lights[index]=new_light
	
	if state==2:
		$Area2D2.monitorable=true
		$Area2D2.monitoring=true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:	

	

	GlobalLight.lights[index]["pos"] = global_position
	GlobalLight.lights[index]["range"] = range
	if state ==0:
		progress+=0.8
	if state==1:
		direction=(get_parent().get_parent().get_node("Player").position-position).normalized()
		position+=direction/2
	if state==2 and isrunafter:
		direction=(get_parent().get_parent().get_node("Player").position-position).normalized()
		position+=direction*2
	if state ==3:
		if range <=0:
			get_parent().get_parent().get_node("CanvasLayer").get_node("LightAndShadow").visible = false
			get_parent().get_parent().get_node("CanvasLayer").get_node("VBoxContainer").visible = true
		
		
		


func _on_area_2d_body_entered(body: Node2D) -> void:
		if body.name == "Player":
			if state ==0:
				body.improlight(range/10,color)
				range=0
				GlobalLight.releasedlights.append(index)
				GlobalLight.lights[index]["range"] = range
				queue_free()
			if state ==1 or state ==2 or state==3:
				range = 0
				GlobalLight.releasedlights.append(index)
				GlobalLight.lights[index]["range"] = range
				body.get_parent().restart()
	
func get_random_color_excluding_red() -> Color:
	var color: Color
	color = Color(randf(), randf(), randf())
	while color.r > 0.7 && color.g < 0.3 && color.b < 0.3 :
			color = Color(randf(), randf(), randf())
	return color
	


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if body.name == "Player":
			if state ==2:
				isrunafter = true


