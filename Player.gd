extends CharacterBody2D

var time =0
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var range:float = 10.0
var before_range:float =0
var isrelease:bool = false


	
func _physics_process(delta: float) -> void:
	time+=delta
	var rotation_speed = 1.0  # 旋转速度（弧度每秒）	
	# 更新 rotating_node 的位置
	var angle = rotation_speed * time  # 计算当前帧的旋转角度
	GlobalLight.lights[0]["pos"] = position + Vector2(cos(angle), sin(angle)) *30
	GlobalLight.lights[0]["range"] =  range


	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	if Input.is_action_just_pressed("boom") and isrelease==false:
		
		if range>=10:
			$boom.play()
			isrelease =true
			before_range=range
			var tween:=create_tween()
			tween.tween_property(self,"range",1000,1)
			for child in get_parent().get_node("enemy").get_children():
				if abs(child.global_position.x - global_position.x)<=547 or abs(child.global_position.y - global_position.y)<=324:
					tween=create_tween()
					tween.tween_property(child,"range",0,1)
			for child in get_parent().get_node("boss").get_children():
				if abs(child.global_position.x - global_position.x)<=547 or abs(child.global_position.y - global_position.y)<=324:
					child.range-=100
			await get_tree().create_timer(1.1).timeout
			for child in get_parent().get_node("enemy").get_children():
				if abs(child.global_position.x - global_position.x)<=547 or abs(child.global_position.y - global_position.y)<=324:
					if child.range == 0:
						GlobalLight.releasedlights.append(child.index)
						child.queue_free()
			await get_tree().create_timer(2).timeout
			tween=create_tween()
			tween.tween_property(self,"range",before_range-10,1)
			isrelease =false


	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			$jump.play()
			velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		$AnimationPlayer.play("walk")
		if not $footsteps_audio.playing and is_on_floor():
			$footsteps_audio.play()
		if not is_on_floor():
			$footsteps_audio.stop()
		if direction > 0:
			$Icon.scale.x = 1  # 面向右侧
		else:
			$Icon.scale.x = -1  # 面向左侧
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		$AnimationPlayer.stop()
		if  $footsteps_audio.playing:
			$footsteps_audio.stop()
	#$AnimationPlayer.play("walk")
	move_and_slide()
	
func improlight(x:float,col:Color)->void:
	$levelup.play()
	range+=x
	GlobalLight.lights[0]["col"] =  col
