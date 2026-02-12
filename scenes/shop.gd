extends Control

var damage_cost = 3
var attack_speed_cost = 10
var size_cost = 20
var large_enemies_cost = 50
var crit_chance_cost = 1

func _ready():
	Global.xp = 100 #remove this
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	set_button_labels()
	set_stats_labels()
	
func set_stats_labels():
	$Stats/XP.text = "EXP: " + str(Global.xp)
	$Stats/DamageLabel.text = "Damage: " + str(Global.damage)
	$Stats/AttackSpeedLabel.text = "Attack Speed: " + str(Global.attack_speed)
	$Stats/CritChanceLabel.text = "Crit Chance: " + str(Global.crit_chance * 100) + "%"
	
func set_button_labels():
	$Buttons/Size.text = "Size (" + str(size_cost) + ")"
	$Buttons/Damage.text = "Damage (" +str(damage_cost) + ")"
	$Buttons/AttackSpeed.text = "Atack Speed (" + str(attack_speed_cost) + ")"
	$Buttons/LargeEnemies.text = "Spawn Large Enemies (" + str(large_enemies_cost) + ")"
	$Buttons/CritChance.text = "Critical Hit Chance (" + str(crit_chance_cost) + ")"
	
func adjust_xp_label():
	$Stats/XP.text = "EXP: " + str(Global.xp)
	
func _process(_delta):
	if Input.is_action_just_pressed("Shop"):
		get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_damage_toggled(_toggled_on):
	if Global.xp >= damage_cost:
		Global.damage += 10
		$Stats/DamageLabel.text = "Damage: " + str(Global.damage)
		Global.xp -= damage_cost
		adjust_xp_label()

func _on_attack_speed_toggled(_toggled_on):
	if Global.attack_speed > 0.4 and Global.xp >= attack_speed_cost:
		Global.attack_speed = snapped(Global.attack_speed - 0.2, 0.1)
		$Stats/AttackSpeedLabel.text = "Attack Speed: " + str(Global.attack_speed)
		Global.xp -= attack_speed_cost
		adjust_xp_label()

func _on_size_toggled(_toggled_on):
	if Global.scale.x <= 3.5 and Global.scale.y <= 3.5 and Global.xp >= size_cost:
		Global.scale.x += 0.5
		Global.scale.y += 0.5
		Global.xp -= size_cost
		adjust_xp_label()

func _on_large_enemies_toggled(_toggled_on):
	if Global.xp >= large_enemies_cost:
		Global.large_enemies = true
		Global.xp -= large_enemies_cost
		adjust_xp_label()

func _on_crit_chance_toggled(_toggled_on):
	if Global.crit_chance < 1.0 and Global.xp >= crit_chance_cost:
		Global.crit_chance = snapped(Global.crit_chance + 0.1, 0.1)
		Global.xp -= crit_chance_cost
		$Stats/CritChanceLabel.text = "Crit Chance: " + str(Global.crit_chance * 100) + "%"
		adjust_xp_label()
