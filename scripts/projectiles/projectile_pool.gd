class_name ProjectilePool
extends Node

## 弹幕对象池管理器
## 按 scene_path 维护多个 ObjectPool，自动延迟创建

var _pools: Dictionary = {}  # scene_path -> ObjectPool


func _ready() -> void:
	name = "ProjectilePool"


func get_projectile(scene_path: String, position: Vector2, direction: Vector2, data: ProjectileData, source: Node = null) -> ProjectileBase:
	## 从池中获取弹幕并初始化
	var pool := _get_or_create_pool(scene_path)
	if pool == null:
		return null
	var proj := pool.acquire() as ProjectileBase
	if proj:
		proj.global_position = position
		proj.initialize(direction, data, source)
	return proj


func release_projectile(proj: ProjectileBase) -> void:
	## 回收弹幕
	var pool := _find_pool_for(proj)
	if pool:
		pool.release(proj)


func _get_or_create_pool(scene_path: String) -> ObjectPool:
	if _pools.has(scene_path):
		return _pools[scene_path]

	var scene := load(scene_path) as PackedScene
	if scene == null:
		push_error("ProjectilePool: Cannot load scene: " + scene_path)
		return null

	var pool := ObjectPool.new()
	pool.init(scene, 20, 200)
	add_child(pool)
	_pools[scene_path] = pool
	return pool


func _find_pool_for(proj: ProjectileBase) -> ObjectPool:
	for pool in _pools.values():
		if proj in pool.get_children():
			return pool
	return null
