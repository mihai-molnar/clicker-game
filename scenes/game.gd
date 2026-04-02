extends Node2D

var small_enemy_scene = preload("res://scenes/enemy.tscn")
var local_life = Global.player_life

func _ready():
	local_life = Global.player_life
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	$Control/XPLabel.text = "EXP: " + str(Global.xp)
	$Control/PlayerLifeLabel.text = "Life: " + str(Global.player_life)
	spawn_enemy("sm")
	
func _process(_delta):
	if Input.is_action_just_pressed("Shop"):
		Global.player_life = local_life
		get_tree().change_scene_to_file("res://scenes/shop.tscn")

func spawn_enemy(variant):
	var enemy = small_enemy_scene.instantiate()
	var viewport_rect = get_viewport_rect()
	var margin = 30
	enemy.position = Vector2(
		randf_range(viewport_rect.position.x + margin, viewport_rect.end.x - margin),
		randf_range(viewport_rect.position.y + margin, viewport_rect.end.y - margin)
	)
	enemy.setup(variant)
	enemy.enemy_died.connect(_on_enemy_died)
	$Entities.add_child(enemy)
	
func decreasePlayerLife(val: int):
	if Global.player_life > 0:
		Global.player_life -= val
	$Control/PlayerLifeLabel.text = "Life: " + str(Global.player_life)
	if Global.player_life <= 0:
		handlePlayerDeath()
		
func handlePlayerDeath():
	Global.player_life = local_life
	get_tree().change_scene_to_file("res://scenes/shop.tscn")

func _on_enemy_spawn_timer_timeout():
	spawn_enemy("sm")
	
func _on_enemy_died(points):
	Global.xp += points
	$Control/XPLabel.text = "EXP: " + str(Global.xp)
	
func _on_large_enemy_spawner_timeout():
	if Global.large_enemies:
		spawn_enemy("lg")

func _on_player_deccrease_player_life(val):
	decreasePlayerLife(val)
