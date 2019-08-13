extends KinematicBody2D

class_name Player

export(int) var _player_speed:int = 250
export(int) var _jump_speed:int = 400
export(int) var _gravity:int = 1000

var _distance:Vector2 = Vector2()
var _direction:Vector2 = Vector2()
var _velocity:Vector2 = Vector2()

onready var _spr: Sprite = $Sprite as Sprite
var state_machine: AnimationNodeStateMachinePlayback

func _ready():
	set_physics_process(true)
	set_process(true)
	state_machine = $AnimationTree.get("parameters/playback")

# warning-ignore:unused_argument
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	move(delta)
	
func move(delta: float) -> void:
# warning-ignore:unused_variable
	#var current = state_machine.get_current_node()
	
	_direction.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	
	if _direction.y != 0:
		state_machine.travel("Jump")
	if _direction.x != 0 and _direction.y == 0:
		state_machine.travel("Run")
	if _direction.x == 0 and _direction.y == 0:
		state_machine.travel("Idle")
	
	if _direction.x > 0:
		_spr.flip_h = false
	elif _direction.x < 0:
		_spr.flip_h = true
	
	_distance.x = _player_speed * delta
	_velocity.x = (_direction.x * _distance.x) / delta
	_velocity.y += _gravity * delta
	
# warning-ignore:return_value_discarded
	move_and_slide(_velocity, Vector2(0, -1))
	
	var _get_collision = get_slide_collision(get_slide_count() -1)
	
	if is_on_floor():
		_velocity.y = 0
		_direction.y = 0
		
		if Input.is_action_just_pressed("ui_up"):
			_velocity.y = -_jump_speed
			_direction.y = 1