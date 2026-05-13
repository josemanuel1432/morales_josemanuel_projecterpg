extends CharacterBody2D

# --- Stats ---
const SPEED = 150.0
var max_health = 100
var health = 100
var level = 1
var xp = 0
var xp_to_next_level = 100
var melee_damage = 10

# --- Estado ---
var is_attacking = false
var is_dead = false
var is_blocking = false
var spawn_position: Vector2

# --- Nodos ---
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_area: Area2D = $AttackArea
@onready var health_bar: ProgressBar = $CanvasLayer/Healthbar
@onready var death_label: Label = $CanvasLayer/DeathLabel
@onready var xp_bar: ProgressBar = $CanvasLayer/XpBar
@onready var level_label: Label = $CanvasLayer/LevelLabel

func _ready():
	attack_area.monitoring = false
	spawn_position = global_position

func _physics_process(_delta):
	if is_attacking or is_dead:
		move_and_slide()
		return
	_handle_blocking()
	_handle_movement()
	_handle_attack_input()
	move_and_slide()

# --------------------------------------------------
# MOVIMIENTO
# --------------------------------------------------
# --------------------------------------------------
# BLOQUEO
# --------------------------------------------------
func _handle_blocking():
	is_blocking = Input.is_action_pressed("click_derecho")

func _handle_movement():
	var dir = Vector2.ZERO
	dir.x = Input.get_axis("ui_left", "ui_right")
	dir.y = Input.get_axis("ui_up", "ui_down")
	if dir != Vector2.ZERO:
		dir = dir.normalized()
		velocity = dir * SPEED
		anim.play("walk")
		anim.flip_h = dir.x > 0
	else:
		velocity = Vector2.ZERO
		anim.play("idle")

# --------------------------------------------------
# ATAQUE
# --------------------------------------------------
func _handle_attack_input():
	if Input.is_action_just_pressed("click_izquierdo") and not is_attacking:
		_do_attack()

func _do_attack():
	is_attacking = true
	velocity = Vector2.ZERO
	var dir_ataque = _get_attack_direction()
	attack_area.position = dir_ataque * 30
	attack_area.monitoring = true
	anim.play("attack")
	await anim.animation_finished
	# Detectar enemigos en el área manualmente
	for body in attack_area.get_overlapping_bodies():
		if body != self and body.has_method("take_damage"):
			body.take_damage(melee_damage)
	attack_area.monitoring = false
	is_attacking = false
	anim.play("idle")

func _get_attack_direction() -> Vector2:
	var mouse_pos = get_global_mouse_position()
	return (mouse_pos - global_position).normalized()

# --------------------------------------------------
# VIDA Y MUERTE
# --------------------------------------------------
func take_damage(amount):
	if is_dead:
		return
	if is_blocking:
		amount = int(amount * 0.4)  # Bloqueo reduce 60% del daño
	health -= amount
	health_bar.value = health
	if health <= 0:
		die()

func die():
	is_dead = true
	health = 0
	health_bar.value = 0
	anim.visible = false
	attack_area.monitoring = false
	death_label.visible = true

	for i in range(5, 0, -1):
		death_label.text = "Has muerto. Reapareciendo en " + str(i) + "..."
		await get_tree().create_timer(1.0).timeout

	# Respawn
	health = max_health
	health_bar.value = max_health
	death_label.visible = false
	anim.visible = true
	is_dead = false
	global_position = spawn_position

func gain_xp(amount):
	xp += amount
	xp_bar.value = xp
	if xp >= xp_to_next_level:
		level_up()

func level_up():
	level += 1
	xp -= xp_to_next_level
	xp_to_next_level = 100 * level
	max_health += 20
	health = max_health
	health_bar.max_value = max_health
	health_bar.value = health
	melee_damage += 5
	xp_bar.max_value = xp_to_next_level
	xp_bar.value = xp
	level_label.text = "Nivel " + str(level)
