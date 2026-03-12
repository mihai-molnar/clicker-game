extends Control

const MAX_ATTACK_SPEED = 0.4
const MAX_SIZE = 3.5
const MAX_CRIT_CHANCE = 1.0

func _ready():
	#Global.xp = 500 #remove this
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	set_button_labels()
	set_stats_labels()
	if Global.attack_speed <= MAX_ATTACK_SPEED:
		set_button_disabled($Buttons/AttackSpeed)
	if Global.scale.x >= MAX_SIZE or Global.scale.y >= MAX_SIZE:
		set_button_disabled($Buttons/Size)
	if Global.large_enemies:
		set_button_disabled($Buttons/LargeEnemies)
	if Global.crit_chance >= MAX_CRIT_CHANCE:
		set_button_disabled($Buttons/CritChance)

func set_stats_labels():
	$Stats/XP.text = "EXP: " + str(Global.xp)
	$Stats/DamageLabel.text = "Damage: " + str(Global.damage)
	$Stats/AttackSpeedLabel.text = "Attack Speed: " + str(Global.attack_speed)
	$Stats/CritChanceLabel.text = "Crit Chance: " + str(Global.crit_chance * 100) + "%"
	
func set_button_labels():
	$Buttons/Size.text = "Size (" + str(Global.size_cost) + ")"
	$Buttons/Damage.text = "Damage (" +str(Global.damage_cost) + ")"
	$Buttons/AttackSpeed.text = "Atack Speed (" + str(Global.attack_speed_cost) + ")"
	$Buttons/LargeEnemies.text = "Spawn Large Enemies (" + str(Global.large_enemies_cost) + ")"
	$Buttons/CritChance.text = "Critical Hit Chance (" + str(Global.crit_chance_cost) + ")"
	
func set_button_disabled(button: Button):
	button.disabled = true
	var base = button.text.split("(")[0].strip_edges()
	button.text = base + "(MAX)"
	
func adjust_xp_label():
	$Stats/XP.text = "EXP: " + str(Global.xp)
	
func increment_cost(cost):
	return cost * 2
	
func _process(_delta):
	if Input.is_action_just_pressed("Shop"):
		get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_damage_toggled(_toggled_on):
	if Global.xp >= Global.damage_cost:
		Global.damage += 10
		$Stats/DamageLabel.text = "Damage: " + str(Global.damage)
		Global.xp -= Global.damage_cost
		Global.damage_cost = increment_cost(Global.damage_cost)
		$Buttons/Damage.text = "Damage (" +str(Global.damage_cost) + ")"
		adjust_xp_label()

func _on_attack_speed_toggled(_toggled_on):
	if Global.attack_speed > MAX_ATTACK_SPEED and Global.xp >= Global.attack_speed_cost:
		Global.attack_speed = snapped(Global.attack_speed - 0.2, 0.1)
		$Stats/AttackSpeedLabel.text = "Attack Speed: " + str(Global.attack_speed)
		Global.xp -= Global.attack_speed_cost
		Global.attack_speed_cost = increment_cost(Global.attack_speed_cost)
		$Buttons/AttackSpeed.text = "Atack Speed (" + str(Global.attack_speed_cost) + ")"
		adjust_xp_label()
	if Global.attack_speed <= MAX_ATTACK_SPEED:
		set_button_disabled($Buttons/AttackSpeed)
		
func _on_size_toggled(_toggled_on):
	if Global.scale.x <= MAX_SIZE and Global.scale.y <= MAX_SIZE and Global.xp >= Global.size_cost:
		Global.scale.x += 0.5
		Global.scale.y += 0.5
		Global.xp -= Global.size_cost
		Global.size_cost = increment_cost(Global.size_cost)
		$Buttons/Size.text = "Size (" + str(Global.size_cost) + ")"
		adjust_xp_label()
	if Global.scale.x >= MAX_SIZE or Global.scale.y >= MAX_SIZE:
		set_button_disabled($Buttons/Size)

func _on_large_enemies_toggled(_toggled_on):
	if !Global.large_enemies and Global.xp >= Global.large_enemies_cost:
		Global.large_enemies = true
		Global.xp -= Global.large_enemies_cost
		adjust_xp_label()
	if Global.large_enemies:
		set_button_disabled($Buttons/LargeEnemies)

func _on_crit_chance_toggled(_toggled_on):
	if Global.crit_chance < MAX_CRIT_CHANCE and Global.xp >= Global.crit_chance_cost:
		Global.crit_chance = snapped(Global.crit_chance + 0.1, 0.1)
		Global.xp -= Global.crit_chance_cost
		$Stats/CritChanceLabel.text = "Crit Chance: " + str(Global.crit_chance * 100) + "%"
		Global.crit_chance_cost = increment_cost(Global.crit_chance_cost)
		$Buttons/CritChance.text = "Critical Hit Chance (" + str(Global.crit_chance_cost) + ")"
		adjust_xp_label()
	if Global.crit_chance >= MAX_CRIT_CHANCE:
		set_button_disabled($Buttons/CritChance)
