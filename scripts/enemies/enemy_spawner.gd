class_name EnemySpawner
extends Node2D

## 敌人生成器 — 波次中从竞技场边缘持续生成敌人

@export var spawn_margin: float = 50.0       # 地图边缘外偏移
@export var min_spawn_interval: float = 0.3  # 最短生成间隔

var arena_size: float = 1200.0
var wave_enemy_pool: Array = []              # [{enemy_data, weight}]
var spawn_timer: float = 0.0
var current_interval: float = 1.0
var enemies_to_spawn: int = 0
var spawned_count: int = 0
var wave_active: bool = false

@onready var enemy_container: Node2D = $".."


func _ready() -> void:
	EventBus.wave_started.connect(_on_wave_started)


func _physics_process(delta: float) -> void:
	if not wave_active:
		return

	spawn_timer += delta
	while spawn_timer >= current_interval and enemies_to_spawn > 0:
		spawn_timer -= current_interval
		_spawn_enemy()
		enemies_to_spawn -= 1
		spawned_count += 1


func _on_wave_started(wave: int) -> void:
	_setup_wave(wave)
	wave_active = true


func _setup_wave(wave: int) -> void:
	# 配额和间隔随波次递增
	enemies_to_spawn = 20 + wave * 5
	spawned_count = 0
	spawn_timer = 0.0
	current_interval = max(min_spawn_interval, 2.0 - wave * 0.1)

	# 配置可生成敌人类型——波次越高解锁越多，数据来自 .tres 文件
	wave_enemy_pool.clear()
	wave_enemy_pool.append({"enemy_data": DataRegistry.get_enemy("en_slime"), "weight": 10})

	if wave >= 2:
		wave_enemy_pool.append({"enemy_data": DataRegistry.get_enemy("en_skeleton"), "weight": 8})
	if wave >= 4:
		wave_enemy_pool.append({"enemy_data": DataRegistry.get_enemy("en_bat"), "weight": 6})
	if wave >= 6:
		wave_enemy_pool.append({"enemy_data": DataRegistry.get_enemy("en_bomber"), "weight": 4})
	if wave >= 8:
		wave_enemy_pool.append({"enemy_data": DataRegistry.get_enemy("en_fatty"), "weight": 2})


func _spawn_enemy() -> void:
	if wave_enemy_pool.is_empty():
		return

	var enemy_data: EnemyData = _pick_random_enemy()
	if enemy_data == null:
		return

	var spawn_pos := _get_random_spawn_position()

	# 动态创建敌人实例
	var enemy := EnemyBase.new()

	var collision := CollisionShape2D.new()
	collision.shape = CircleShape2D.new()
	collision.shape.radius = enemy_data.size

	var sprite := ColorRect.new()
	sprite.size = Vector2(enemy_data.size * 2, enemy_data.size * 2)
	sprite.position = -Vector2(enemy_data.size, enemy_data.size)
	sprite.color = enemy_data.color

	# 精英加倍大小
	if enemy_data.is_elite:
		sprite.size *= 1.5
		sprite.position = -sprite.size / 2.0

	enemy.add_child(collision)
	enemy.add_child(sprite)
	enemy.global_position = spawn_pos

	# 查找玩家并初始化
	var player := get_tree().get_first_node_in_group("player")
	if player:
		enemy.setup(enemy_data, player)

	enemy_container.add_child(enemy)


## 加权随机选择敌人
func _pick_random_enemy() -> EnemyData:
	var total_weight := 0.0
	for entry in wave_enemy_pool:
		total_weight += entry["weight"]

	var roll := randf() * total_weight
	var cumulative := 0.0
	for entry in wave_enemy_pool:
		cumulative += entry["weight"]
		if roll <= cumulative:
			return entry["enemy_data"]

	return wave_enemy_pool[0]["enemy_data"]


## 从竞技场4条边随机选生成位置
func _get_random_spawn_position() -> Vector2:
	var half := arena_size / 2.0 + spawn_margin
	var side := randi() % 4
	match side:
		0: return Vector2(randf_range(-half, half), -half)  # 上
		1: return Vector2(randf_range(-half, half), half)   # 下
		2: return Vector2(-half, randf_range(-half, half))  # 左
		3: return Vector2(half, randf_range(-half, half))   # 右
	return Vector2.ZERO


func stop_wave() -> void:
	wave_active = false
	enemies_to_spawn = 0
