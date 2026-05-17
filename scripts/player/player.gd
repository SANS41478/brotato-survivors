extends CharacterBody2D

## 玩家控制器

@onready var stats: PlayerStats = PlayerStats.new()

var current_hp: float = 100.0
var is_dead: bool = false

## 移动输入
var input_vector: Vector2 = Vector2.ZERO


func _ready() -> void:
	add_to_group("player")
	current_hp = stats.max_hp


func _physics_process(_delta: float) -> void:
	if is_dead:
		return

	_handle_movement()


func _handle_movement() -> void:
	input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_vector * stats.get_final_move_speed()

	if velocity.length() > 0:
		pass

	move_and_slide()

	# 碰撞检测（接触伤害由敌人处理）
	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		var collider := collision.get_collider()
		if collider and collider.is_in_group("enemies"):
			var damage = collider.get("contact_damage")
			if typeof(damage) in [TYPE_FLOAT, TYPE_INT]:
				take_damage(float(damage), collider)


func take_damage(amount: float, source: Node = null) -> void:
	if is_dead:
		return

	# 闪避判定
	if randf() < stats.dodge:
		return

	# 护甲减伤
	var reduction := stats.get_damage_reduction()
	var final_damage := amount * (1.0 - reduction)

	current_hp -= final_damage
	EventBus.player_health_changed.emit(current_hp, stats.max_hp)
	EventBus.player_damaged.emit(final_damage, source)

	if current_hp <= 0:
		_die()


func heal(amount: float) -> void:
	current_hp = min(current_hp + amount, stats.max_hp)
	EventBus.player_health_changed.emit(current_hp, stats.max_hp)


func _die() -> void:
	is_dead = true
	GameManager.change_state(GameManager.GameState.GAME_OVER)


func get_position_2d() -> Vector2:
	return global_position


func get_stats() -> PlayerStats:
	return stats


func is_alive() -> bool:
	return not is_dead
