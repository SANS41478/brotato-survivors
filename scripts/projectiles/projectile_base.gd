class_name ProjectileBase
extends Area2D

## 弹幕基类
## 按方向和速度飞行，命中敌人消耗穿透，穿透耗尽或超生命周期停用

var data: ProjectileData
var direction: Vector2 = Vector2.RIGHT
var distance_traveled: float = 0.0
var remaining_pierce: int = 0
var is_active: bool = false
var source: Node = null


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func initialize(dir: Vector2, proj_data: ProjectileData, src: Node = null) -> void:
	direction = dir.normalized()
	data = proj_data
	remaining_pierce = data.pierce
	source = src
	distance_traveled = 0.0
	is_active = true

	rotation = dir.angle()
	modulate = data.color
	scale = Vector2(data.scale, data.scale)

	visible = true
	process_mode = Node.PROCESS_MODE_INHERIT


func _physics_process(delta: float) -> void:
	if not is_active:
		return

	var movement := direction * data.speed * delta
	global_position += movement
	distance_traveled += movement.length()

	if distance_traveled > data.lifetime * data.speed:
		_deactivate()


func _on_body_entered(body: Node2D) -> void:
	# 不碰撞发射源
	if body == source:
		return
	if body.is_in_group("enemies"):
		_hit_target(body)


func _hit_target(target: Node) -> void:
	if target.has_method("take_damage"):
		target.take_damage(data.damage, source)

	remaining_pierce -= 1
	if remaining_pierce < 0:
		_deactivate()


func _deactivate() -> void:
	is_active = false
	visible = false
	process_mode = Node.PROCESS_MODE_DISABLED
