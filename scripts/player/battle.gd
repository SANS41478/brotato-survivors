extends Node2D

## 战斗场景主控

@onready var entities_node: Node2D = $Entities
@onready var player_container: Node2D = $Entities/PlayerContainer
@onready var enemy_container: Node2D = $Entities/EnemyContainer
@onready var projectiles_node: Node2D = $Projectiles
@onready var pickups_node: Node2D = $Pickups

## ARENA_SIZE 必须与 ColorRect 尺寸一致
const ARENA_SIZE: float = 1200.0


func _ready() -> void:
	# 设置玩家相机边界
	_setup_camera_limits()
	GameManager.change_state(GameManager.GameState.BATTLE)


func _setup_camera_limits() -> void:
	# 获取玩家的 Camera2D（Player.tscn 中已配置 current=true）
	var player: Node = player_container.get_child(0) if player_container.get_child_count() > 0 else null
	if player and player.has_node("Camera2D"):
		var camera: Camera2D = player.get_node("Camera2D")
		camera.limit_left = int(-get_arena_half())
		camera.limit_right = int(get_arena_half())
		camera.limit_top = int(-get_arena_half())
		camera.limit_bottom = int(get_arena_half())


func get_arena_half() -> float:
	return ARENA_SIZE / 2.0


func is_in_arena(pos: Vector2) -> bool:
	var half := get_arena_half()
	return abs(pos.x) < half and abs(pos.y) < half


func clamp_to_arena(pos: Vector2) -> Vector2:
	var half := get_arena_half()
	return Vector2(
		clamp(pos.x, -half + 16, half - 16),
		clamp(pos.y, -half + 16, half - 16)
	)
