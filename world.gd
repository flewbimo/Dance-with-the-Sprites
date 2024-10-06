extends Node2D

@onready var player: CharacterBody2D = $Player
const MAP_SPIRTE = preload("res://map_spirte.tscn")
var instance

func _ready() -> void:
	Engine.time_scale=1
	pass # Replace with function body.


func _process(delta: float) -> void:
	$CanvasLayer/progress.value=$boss/map_spirte54.range/1500



func _on_enemy_timer_timeout() -> void:
	for y in range(-300,300,100):
		for x in [-1200,1200]:
			instance = MAP_SPIRTE.instantiate()
			instance.color = Color.RED
			instance.range = 100
			instance.state = 1
			instance.global_position=player.global_position+Vector2(x,y)
			$enemy.add_child(instance)
			$bell.play()
func _on_enemy_timer_2_timeout() -> void:
	for y in range(0,300,100):
		for x in [-600,600]:
			instance = MAP_SPIRTE.instantiate()
			instance.color = Color.RED
			instance.range = 100
			instance.state = 2
			instance.global_position=player.global_position+Vector2(x,y)
			$enemy.add_child(instance)		
			$bell.play()
				
func restart()->void:
	$CanvasLayer/VBoxContainer.visible=true
	Engine.time_scale=0


func _on_restartbtn_pressed() -> void:
	get_tree().reload_current_scene()
	GlobalLight.lights.resize(1)
	GlobalLight.releasedlights.resize(0)



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		$enemyTimer.stop()
		$enemyTimer2.start()


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		$enemyTimer.stop()



func _on_area_2d_3_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		for child in $spirte.get_children():
			if child is PathFollow2D:
				GlobalLight.releasedlights.append(child.index)
				child.queue_free()
			else:
				for child2 in child.get_children():
					GlobalLight.releasedlights.append(child2.index)
					child2.queue_free()
		for child in $enemy.get_children():
			GlobalLight.releasedlights.append(child.index)
			child.queue_free()
		$enemyTimer2.start()
		$spirtTimer.start()
		for i in range(1,30):
			_on_spirt_timer_timeout()
		$CanvasLayer/progress.visible=true
		$wind.play()
		
		

func _on_spirt_timer_timeout() -> void:
	instance = MAP_SPIRTE.instantiate()
	instance.range = 30
	instance.state = 0
	$spirte/Path2D7.add_child(instance)	
