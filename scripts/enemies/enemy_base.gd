class_name EnemyBase
extends CharacterBody2D

## 敌人基类——AI行为、受击、死亡

var enemy_data: EnemyData
var current_hp: float = 0.0
var player_ref: Node2D = null
var is_dead: bool = false
var current_speed: float = 0.0


func _ready() -> void:
	add_to_group("enemies")


func setup(data: EnemyData, player: Node2D) -> void:
	enemy_data = data
	player_ref = player
	current_hp = data.max_hp
	current_speed = data.move_speed


func _physics_process(delta: float) -> void:
	if is_dead or player_ref == null:
		return

	if not player_ref.has_method("is_alive") or not player_ref.is_alive():
		return

	match enemy_data.behavior:
		EnemyData.BehaviorType.CHASE:
			_behavior_chase(delta)
		EnemyData.BehaviorType.CHARGE:
			_behavior_charge(delta)
		EnemyData.BehaviorType.RANGED:
			_behavior_ranged(delta)


## 追踪行为——直冲玩家
func _behavior_chase(delta: float) -> void:
	var direction := (player_ref.global_position - global_position).normalized()
	velocity = direction * current_speed
	move_and_slide()


## 冲锋行为——追踪 + 1.5 倍速
func _behavior_charge(delta: float) -> void:
	var direction := (player_ref.global_position - global_position).normalized()
	velocity = direction * current_speed * 1.5
	move_and_slide()


## 远程行为——保持 150px 最佳距离
func _behavior_ranged(delta: float) -> void:
	var to_player := player_ref.global_position - global_position
	var dist := to_player.length()
	var preferred_dist := 150.0

	if dist > preferred_dist + 20:
		velocity = to_player.normalized() * current_speed
	elif dist < preferred_dist - 20:
		velocity = -to_player.normalized() * current_speed
	else:
		velocity = Vector2.ZERO
	move_and_slide()


## 受击——减血、白闪、HP≤0 死亡
func take_damage(amount: float, source: Node = null) -> void:
	if is_dead:
		return

	current_hp -= amount
	_flash_white()

	if current_hp <= 0:
		die(source)


## 死亡——标记、发信号、清理
func die(source: Node = null) -> void:
	if is_dead:
		return
	is_dead = true
	velocity = Vector2.ZERO

	EventBus.enemy_killed.emit(self, global_position, enemy_data.xp_value, enemy_data.gold_value)

	queue_free()


func is_alive() -> bool:
	return not is_dead


## 受击白闪效果
func _flash_white() -> void:
	modulate = Color.WHITE
	var tween := create_tween()
	tween.tween_property(self, "modulate", enemy_data.color, 0.1)
