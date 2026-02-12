extends CharacterBody2D

var variant: String
var life: int
var speed = 150
var direction: Vector2

signal enemy_died(val)

var explosion_scene = preload("res://scenes/explosion.tscn")

func setup(type):
	variant = type

func _ready():
	if variant == "sm":
		life = 50
	if variant == "lg":
		life = 70
		scale = Vector2(1.5, 1.5)
	$Life.text = str(life)
	direction = Vector2.from_angle(randf() * TAU)

func _process(delta):
	var viewport_rect = get_viewport_rect()
	var margin = 20

	var at_edge = (position.x < viewport_rect.position.x + margin and direction.x < 0) or \
		(position.x > viewport_rect.end.x - margin and direction.x > 0) or \
		(position.y < viewport_rect.position.y + margin and direction.y < 0) or \
		(position.y > viewport_rect.end.y - margin and direction.y > 0)

	if at_edge:
		var to_center = (viewport_rect.get_center() - position).normalized()
		direction = to_center.rotated(randf_range(-PI / 4, PI / 4))

	position += direction * speed * delta

func hit(dmg):
	life -= dmg
	$Life.text = str(life)
	if life <= 0:
		die()
		return
		
func die():
	var xp = 1
	if variant == "lg":
		xp = 2
	enemy_died.emit(xp)
	var explosion = explosion_scene.instantiate()
	explosion.position = global_position
	get_tree().current_scene.add_child(explosion)
	queue_free()
		
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
