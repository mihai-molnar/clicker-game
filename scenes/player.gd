extends CharacterBody2D

var enemies: Array = []

func _ready():
	$Sprite2D.modulate.a = 0.2
	$CollisionShape2D.disabled = true
	scale = Global.scale
	$ShootTimer.wait_time = Global.attack_speed

func _process(_delta):
	position = get_global_mouse_position()

func flash():
	$Sprite2D.modulate.a = 1.0
	var tween = create_tween()
	tween.tween_property($Sprite2D, "modulate:a", 0.2, 0.15)

func _on_shoot_timer_timeout():
	flash()
	var rand = randf_range(0, 1);
	var crit = 1
	if rand <= Global.crit_chance:
		crit = 2
	if enemies.is_empty():
		return
	for enemy in enemies:
		enemy.hit(Global.damage * crit)

func _on_damage_area_body_entered(body):
	enemies.append(body)

func _on_damage_area_body_exited(body):
	enemies.erase(body)
