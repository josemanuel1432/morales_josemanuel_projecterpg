extends CharacterBody2D

# --- Stats ---
const SPEED = 150.0

# --- Estado ---
var is_attacking = false

# --- Nodos ---
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_area: Area2D = $AttackArea

func _ready():
	attack_area.monitoring = false  # El área solo activa al atacar

func _physics_process(_delta):
	if is_attacking:
		move_and_slide()
		return  # No mover mientras ataca

	_handle_movement()
	_handle_attack_input()
	move_and_slide()

# --------------------------------------------------
# MOVIMIENTO
# --------------------------------------------------
func _handle_movement():
	var dir = Vector2.ZERO
	dir.x = Input.get_axis("ui_left", "ui_right")
	dir.y = Input.get_axis("ui_up", "ui_down")

	if dir != Vector2.ZERO:
		dir = dir.normalized()
		velocity = dir * SPEED
		anim.play("walk")
		# Flip horizontal según dirección
		anim.flip_h = dir.x < 0
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

	# Posicionar el AttackArea según donde mira el personaje
	var dir_ataque = _get_attack_direction()
	attack_area.position = dir_ataque * 30  # 30px delante del jugador

	# Activar área de golpe
	attack_area.monitoring = true

	# Reproducir animación
	anim.play("attack")

	# Esperar a que termine la animación
	await anim.animation_finished

	# Desactivar área
	attack_area.monitoring = false
	is_attacking = false
	anim.play("idle")

func _get_attack_direction() -> Vector2:
	# La dirección del ataque apunta hacia el ratón
	var mouse_pos = get_global_mouse_position()
	var dir = (mouse_pos - global_position).normalized()
	return dir
