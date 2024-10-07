extends Node2D

const LIGHT_N: int = 99999

var light_pos: Array[Vector2]
var light_col: Array[Color]
var light_range: Array[float]
var light_ang: Array[float]
var light_fan_ang: Array[float]
var lights: Array[Dictionary]
var time: float

@onready var light_and_shadow = $"../../CanvasLayer/LightAndShadow"
@onready var player: CharacterBody2D = $"../../Player"
@onready var camera_2d: Camera2D = player.get_node("Camera2D")


func _ready():

	lights = GlobalLight.lights	
	light_pos.resize(LIGHT_N)
	light_range.resize(LIGHT_N)
	light_col.resize(LIGHT_N)
	light_ang.resize(LIGHT_N)
	light_fan_ang.resize(LIGHT_N)


func _physics_process(delta):
	
	time += delta
	
	for i in range(lights.size()):
		
		light_pos[i] = lights[i]["pos"]
		light_col[i] = lights[i]["col"]
		light_range[i] = lights[i]["range"]
		light_ang[i] = lights[i]["ang"]
		light_fan_ang[i] = lights[i]["fan_ang"]

	light_and_shadow.material.set_shader_parameter("light_n", lights.size())
	light_and_shadow.material.set_shader_parameter("light_pos", light_pos)
	light_and_shadow.material.set_shader_parameter("light_col", light_col)
	light_and_shadow.material.set_shader_parameter("light_rng", light_range)
	light_and_shadow.material.set_shader_parameter("light_ang", light_ang)
	light_and_shadow.material.set_shader_parameter("light_fan_ang", light_fan_ang)
	
	var trans_comp: Transform2D = get_global_transform_with_canvas()
	light_and_shadow.material.set_shader_parameter("comp_mat", trans_comp)
	light_and_shadow.material.set_shader_parameter("zoom", camera_2d.zoom.x)
	light_and_shadow.material.set_shader_parameter("rotation", camera_2d.global_rotation)
