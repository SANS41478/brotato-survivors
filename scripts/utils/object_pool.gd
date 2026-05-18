class_name ObjectPool
extends Node

## 通用对象池
## 预创建实例，回收复用，避免高频 instantiate

var _pool: Array = []
var _scene: PackedScene
var _max_size: int


func init(scene: PackedScene, initial_size: int = 50, max_size: int = 500) -> void:
	_scene = scene
	_max_size = max_size
	for i in initial_size:
		_create_instance()


func _create_instance() -> Node:
	var instance := _scene.instantiate()
	instance.visible = false
	instance.process_mode = Node.PROCESS_MODE_DISABLED
	add_child(instance)
	_pool.append(instance)
	return instance


func acquire() -> Node:
	## 获取一个可用实例
	for instance in _pool:
		if not instance.visible:
			instance.visible = true
			instance.process_mode = Node.PROCESS_MODE_INHERIT
			return instance

	# 池未满则创建新实例
	if _pool.size() < _max_size:
		return _create_instance()

	# 池满——复用最老实例
	var oldest := _pool[0]
	oldest.visible = false
	oldest.process_mode = Node.PROCESS_MODE_DISABLED
	_pool.erase(oldest)
	_pool.append(oldest)
	oldest.visible = true
	oldest.process_mode = Node.PROCESS_MODE_INHERIT
	return oldest


func release(instance: Node) -> void:
	## 回收实例到池中
	instance.visible = false
	instance.process_mode = Node.PROCESS_MODE_DISABLED


func get_active_count() -> int:
	var count := 0
	for inst in _pool:
		if inst.visible:
			count += 1
	return count
