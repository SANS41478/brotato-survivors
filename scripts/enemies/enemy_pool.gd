class_name EnemyPool
extends Node

## 敌人对象池 — 复用 EnemyBase 实例，避免高频 new / queue_free

var _pool: ObjectPool


func _ready() -> void:
	_pool = ObjectPool.new()
	add_child(_pool)
	name = "EnemyPool"


## 获取敌人实例（从池中复用或新建）
func acquire_enemy(data: EnemyData, position: Vector2, player: Node2D) -> EnemyBase:
	var scene := _get_enemy_scene()
	# 首次调用时初始化池
	if _pool._scene == null:
		_pool.init(scene, 30, 300)

	var enemy := _pool.acquire() as EnemyBase
	if enemy == null:
		return null

	# 清理旧状态——重新创建碰撞和精灵
	_clear_children(enemy)
	_build_visuals(enemy, data)
	enemy.global_position = position
	enemy.setup(data, player)
	return enemy


## 回收敌人到池
func release_enemy(enemy: EnemyBase) -> void:
	enemy.is_dead = true
	enemy.velocity = Vector2.ZERO
	_pool.release(enemy)


## 动态创建碰撞体 + 占位精灵
func _build_visuals(enemy: EnemyBase, data: EnemyData) -> void:
	var collision := CollisionShape2D.new()
	collision.shape = CircleShape2D.new()
	collision.shape.radius = data.size

	var sprite := ColorRect.new()
	sprite.size = Vector2(data.size * 2, data.size * 2)
	sprite.position = -Vector2(data.size, data.size)
	sprite.color = data.color

	if data.is_elite:
		sprite.size *= 1.5
		sprite.position = -sprite.size / 2.0

	enemy.add_child(collision)
	enemy.add_child(sprite)


## 移除所有子节点（碰撞体/精灵/旧tween）
func _clear_children(enemy: EnemyBase) -> void:
	for child in enemy.get_children():
		child.queue_free()


## 获取通用敌人场景（运行时动态创建）
func _get_enemy_scene() -> PackedScene:
	var scene := PackedScene.new()
	var enemy := EnemyBase.new()
	scene.pack(enemy)
	enemy.queue_free()
	return scene
