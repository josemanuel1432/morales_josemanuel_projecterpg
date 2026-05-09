extends CharacterBody2D

# --- Stats ---
var max_health = 30
var health = 30
var speed = 60.0
var damage = 2
var attack_cooldown = 1.5

# --- Estado ---
var player = null
var can_attack = true

@onready var sprite: Sprite2D = $Sprite2D
@onready var health_bar: ProgressBar = $HealthBar

func _ready():
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	if player == null:
		return

	var dir = (player.global_position - global_position)
	var dist = dir.length()

	if dist > 30:
		global_position += dir.normalized() * speed * delta
		sprite.flip_h = dir.x < 0

	if dist < 30 and can_attack:
		_attack_player()

func _attack_player():
	can_attack = false
	player.take_damage(damage)
	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true

func take_damage(amount):
	health -= amount
	health_bar.value = health
	if health <= 0:
		die()

func die():
	queue_free()
