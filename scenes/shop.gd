extends Control

func _process(_delta):
	if Input.is_action_just_pressed("Shop"):
		get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_damage_toggled(_toggled_on):
	Global.damage += 10

func _on_attack_speed_toggled(_toggled_on):
	Global.attack_speed = 0.8

func _on_size_toggled(_toggled_on):
	Global.scale = Vector2(1.5, 1.5)

func _on_large_enemies_toggled(_toggled_on):
	Global.large_enemies = true

func _on_crit_chance_toggled(_toggled_on):
	if Global.crit_chance < 0.9:
		Global.crit_chance += 0.1
	
