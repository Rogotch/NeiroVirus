extends CharacterBody2D
class_name base_character

enum STATES {IDLE, DASH, ATTACK, MOVE, RELOADING}

@export var id                   : int
@export var room                 : int
@export var sprite_offset        : Vector2
@export var player_flag          : bool
@export_group("Nodes")
@export var collision_shape      : CollisionShape2D
@export var bullet_point         : Node2D
@export var sprite               : Sprite2D
@export var firing_rate_timer    : Timer
@export var corruption_timer     : Timer
@export var dash_timer           : Timer
@export var characters_cast      : RayCast2D
@export var anim_tree            : AnimationTree
@export var navigation_agent     : NavigationAgent2D
@export var health_bar           : ProgressBar
@export var corruption_bar       : ProgressBar
@export var ammo_label           : Label

var my_parameters : unit_parameters      =   unit_parameters.new()
var my_controller : character_controller 

var my_state : STATES = STATES.IDLE
#@onready var bullet_class = preload("res://Entities/bullet.tscn") 

var bullet_point_offset  : Vector2

var state_machine     = null
var can_shoot_flag   := true
var can_dash_flag    := true
var reloading_flag   := false
var can_corrupt_flag := false
var dash_flag        := false

var active_flag := false
var show_raycast_flag := false

func _ready() -> void:
	add_to_group("units")
	my_parameters.death.connect(death)
	my_parameters.health_changed.connect(update_hp_bar)
	my_parameters.ammo_changed.connect(update_ammo_label)
	my_parameters.load_parameters(id)
	corruption_bar.max_value = my_parameters.corruption_cooldown
	first_set_controller()
	state_machine = anim_tree.get("parameters/playback")
	bullet_point_offset = bullet_point.position
	pass

func _physics_process(delta: float) -> void:
	corruption_bar.value = my_parameters.corruption_cooldown - corruption_timer.time_left
	var states_flag =  my_state == STATES.DASH || my_state == STATES.ATTACK
	var on_point_flag = my_controller != null && my_controller.is_enemy() && navigation_agent.is_navigation_finished()
	var wait_in_room_flag = !player_flag && !active_flag
#	prints(wait_in_room_flag, !player_flag, active_flag)
	if my_controller == null || states_flag || on_point_flag || wait_in_room_flag:
		change_state(STATES.IDLE)
		return
	
	var move_target = my_controller.get_move_target()
	
#	if move_target.x != 0 && can_shoot_flag:
	flip_to_point(my_controller.get_target())
	
	velocity = lerp(velocity, my_parameters.speed * my_controller.get_move_target(), my_parameters.slide_value)
	move_and_slide()
#	print(velocity.length())
	my_controller.detect_enemy()
	
	if velocity.length() <= 25:
		change_state(STATES.IDLE)
	else:
		change_state(STATES.MOVE)
	pass

func update_pathfiding():
	if my_controller != null && Global.player != my_controller && active_flag:
		navigation_agent.set_target_position(my_controller.get_target())
	pass

func activate(room_id : int):
	if room_id == room:
		active_flag = true
	pass

func flip_to_point(point : Vector2):
	flip(point.x < global_position.x)
	pass

func flip_to_direction(direction : Vector2):
	flip(direction.x < 0)
	pass

func flip(flag : bool):
	sprite.flip_h = flag
	sprite.offset = sprite_offset * (-1 if flag else 1)
	bullet_point.position.x = bullet_point_offset.x * (-1 if flag else 1)
	pass

func dash(target_direction = my_controller.get_move_target()):
	if target_direction.length() == 0 || my_state == STATES.DASH || !can_dash_flag:
		return
	
	var dash_power = my_parameters.dash_distance / my_parameters.dash_time
	velocity = target_direction * dash_power
	
	change_state(STATES.DASH)
	
	var dash_tween = create_tween()
	dash_tween.tween_callback(clear_mask)
	dash_tween.tween_callback(clear_layers)
	dash_tween.tween_method(dash_move, 0, 0, my_parameters.dash_time)
#	dash_tween.tween_property(self, "global_position", target , my_parameters.dash_time)
#	dash_tween.tween_interval(my_parameters.dash_time)
	dash_tween.tween_callback(dash_end)
	dash_tween.play()
	
	can_dash_flag = false
	dash_timer.start(my_parameters.dash_cooldown)
	
	pass

func dash_move(_value):
	move_and_slide()
	
	pass

func dash_end():
	change_state(STATES.IDLE)
	velocity = velocity * 0.1
	update_collision_layers_and_masks()
	pass

func change_state(new_state : STATES):
	match new_state:
		STATES.RELOADING:
			reloading_flag = true
		STATES.MOVE:
			if my_state != STATES.MOVE:
				my_state = STATES.MOVE
				play_animation("move")
		STATES.IDLE:
			if my_state != STATES.IDLE:
				my_state = STATES.IDLE
				play_animation("idle")
		STATES.DASH:
			if my_state != STATES.DASH:
				my_state = STATES.DASH
		STATES.ATTACK:
#			if my_state != STATES.ATTACK:
#				my_state = STATES.ATTACK
			play_animation("attack")
	pass

func attack(target : Vector2):
	if can_shoot_flag && my_parameters.ammo > 0 && my_state != STATES.RELOADING:
		can_shoot_flag = false
		my_parameters.ammo -= 1
		flip_to_point(target)
		change_state(STATES.ATTACK)
		
		var bullet = GameObjects.bullet_class.instantiate()
		bullet.set_masks(my_controller.get_bullet_collision_mask())
		bullet = bullet as RigidBody2D
		bullet.set_bullet_params(my_parameters)
		get_parent().add_child(bullet)
		
		bullet.global_position = bullet_point.global_position
		bullet.look_at(target)
#		var rng = Global.rng as RandomNumberGenerator
		bullet.shoot_me(target)
		
		firing_rate_timer.start(my_parameters.fire_rate)
	elif my_parameters.ammo == 0 && !reloading_flag:
		reload_start()
	pass

func targeting_for_corruption(target : Vector2):
	show_raycast_flag = true
	var direction = global_position.direction_to(target)
	characters_cast.target_position = direction * my_parameters.corruption_distance
	queue_redraw()
	pass

func try_corrupt():
	if characters_cast.is_colliding() && can_corrupt_flag:
		var collider = characters_cast.get_collider()
		if collider is base_character:
			cure_corruption()
			collider.corrupt()
	pass

func try_attack():
	if characters_cast.is_colliding():
		var collider = characters_cast.get_collider()
		if collider is base_character:
			attack(my_controller.get_target())
	pass

func first_set_controller():
	if player_flag:
		corrupt()
	else:
		corruption_bar.visible = false
		
		my_controller = enemy_controller.new(self)
		update_collision_layers_and_masks()
		sprite.use_parent_material = false
	update_ammo_label()
	pass

func corrupt():
	corruption_bar.visible = true
	player_flag = true
	can_corrupt_flag = false
	corruption_timer.start(my_parameters.corruption_cooldown)
	my_controller = player_controller.new(self)
	Global.player = my_controller
	update_collision_layers_and_masks()
	sprite.use_parent_material = true
	pass

func cure_corruption():
	queue_redraw()
	corruption_bar.visible = false
	player_flag = false
	Global.player = null
	my_controller = enemy_controller.new(self)
	update_collision_layers_and_masks()
	sprite.use_parent_material = false
	pass

func can_shoot():
	can_shoot_flag   = true
	match my_state:
		STATES.MOVE:
			play_animation("move")
		STATES.IDLE:
			play_animation("idle")
	pass

func can_dash():
	print_debug("can dash!")
	can_dash_flag    = true
	pass

func can_corrupt():
	can_corrupt_flag = true
	pass

func reload_start():
	reloading_flag = true
#	change_state(STATES.RELOADING)
#	print("star reloading!")
	var reload_tween = create_tween()
	reload_tween.tween_interval(my_parameters.reloading_time)
	reload_tween.tween_callback(reload_end)
	reload_tween.play()
	pass

func reload_end():
	my_parameters.ammo = my_parameters.ammo_max
	reloading_flag = false
#	match my_state:
#		STATES.MOVE:
#			play_animation("move")
#		STATES.IDLE:
#			play_animation("idle")
	pass

func hit(value : float):
	my_parameters.health -= value
	pass

func death():
	if Global.player != null && Global.player == my_controller:
		Global.player = null
	queue_free()
	pass

func _draw() -> void:
	if my_controller != null && !my_controller.is_enemy() && show_raycast_flag:
		
		draw_line(Vector2.ZERO, characters_cast.target_position, Color.FIREBRICK, 2)
	pass

func update_collision_layers_and_masks():
	set_layers(my_controller.get_collision_layers())
	set_masks(my_controller.get_collision_mask())
	set_detector_masks(my_controller.get_bullet_collision_mask())
	pass

func set_detector_masks(layers_dictionary : Dictionary):
	for layer in layers_dictionary.keys():
		characters_cast.set_collision_mask_value(layer, layers_dictionary[layer])
	pass

func set_layers(layers_dictionary : Dictionary):
	for layer in layers_dictionary.keys():
		set_collision_layer_value(layer, layers_dictionary[layer])
	pass

func clear_layers():
	for layer in range(1, 6):
		set_collision_layer_value(layer, false)
	pass

func clear_mask():
	for layer in range(1, 6):
		if layer == 2:
			continue
		set_collision_mask_value(layer, false)
	pass

func set_masks(masks_dictionary : Dictionary):
	for layer in masks_dictionary.keys():
		set_collision_mask_value(layer, masks_dictionary[layer])
	pass

func play_animation(anim_name):
	state_machine.travel(anim_name)
	pass

func update_hp_bar():
	health_bar.max_value = my_parameters.max_health
	health_bar.value = my_parameters.health
	pass

func update_ammo_label():
	ammo_label.text = str(my_parameters.ammo) + "/" + str(my_parameters.ammo_max)
	pass
