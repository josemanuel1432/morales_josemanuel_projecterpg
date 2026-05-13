extends CharacterBody2D

# --- Stats ---
var max_health = 30
var health = 30
var speed = 60.0
var damage = 6
var attack_cooldown = 1.5
var detection_range = 100.0

# --- Estado ---
var player = null
var can_attack = true
var spawn_position: Vector2
var is_chasing = false

@onready var sprite: Sprite2D = $Sprite2D
@onready var health_bar: ProgressBar = $HealthBar
@onready var respawn_label: Label = $RespawnLabel

func _ready():
	player = get_tree().get_first_node_in_group("player")
	spawn_position = global_position

func _physics_process(delta):
	if player == null:
		return

	var dir = (player.global_position - global_position)
	var dist = dir.length()

	if dist < detection_range:
		is_chasing = true

	if not is_chasing:
		return

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
	player.gain_xp(10)
	is_chasing = false
	sprite.visible = false
	health_bar.visible = false
	set_physics_process(false)
	global_position = spawn_position
	respawn_label.visible = true
	for i in range(5, 0, -1):
		respawn_label.text = str(i) + "s"
		await get_tree().create_timer(1.0).timeout
	respawn_label.visible = false
	health = max_health
	health_bar.value = max_health
	sprite.visible = true
	health_bar.visible = true
	set_physics_process(true)
