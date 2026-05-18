class_name WeaponBase
extends Node2D

## 武器基类 — 挂载到玩家节点下，自动攻击

var weapon_data: WeaponData
var attack_timer: float = 0.0

var player_ref: Node2D = null
var projectile_pool_ref: ProjectilePool = null


func setup(data: WeaponData, player: Node2D, pool: ProjectilePool) -> void:
	weapon_data = data
	player_ref = player
	projectile_pool_ref = pool
	attack_timer = 0.0


func _physics_process(delta: float) -> void:
	if weapon_data == null or player_ref == null:
		return

	attack_timer += delta
	var interval := 1.0 / (weapon_data.base_attack_speed * _get_attack_speed_mult())

	while attack_timer >= interval:
		attack_timer -= interval
		_attack()


func _get_attack_speed_mult() -> float:
	if player_ref and player_ref.has_method("get_stats"):
		return player_ref.get_stats().get_final_attack_speed()
	return 1.0


func _get_damage_mult() -> float:
	if player_ref and player_ref.has_method("get_stats"):
		var stats = player_ref.get_stats()
		var mult := stats.get_final_damage()
		if weapon_data.type == WeaponData.WeaponType.MELEE:
			mult += stats.melee_damage
		elif weapon_data.type == WeaponData.WeaponType.RANGED:
			mult += stats.ranged_damage
		return max(mult, 0.1)
	return 1.0


func _attack() -> void:
	match weapon_data.type:
		WeaponData.WeaponType.RANGED:
			_fire_ranged()
		WeaponData.WeaponType.MELEE:
			_fire_melee()
		WeaponData.WeaponType.AOE:
			_fire_aoe()
		_:
			_fire_ranged()


## 获取所有敌人，按距离排序
func _get_targets() -> Array[Node2D]:
	var enemies := get_tree().get_nodes_in_group("enemies")
	if enemies.is_empty():
		return []

	var player_pos := player_ref.global_position
	var sorted := []
	for enemy in enemies:
		if not enemy.has_method("is_alive") or enemy.is_alive():
			var dist := player_pos.distance_squared_to(enemy.global_position)
			sorted.append({"enemy": enemy, "dist": dist})

	sorted.sort_custom(func(a, b): return a["dist"] < b["dist"])

	var target_positions: Array[Node2D] = []
	for entry in sorted:
		target_positions.append(entry["enemy"])

	return target_positions


## 远程射击——向最近敌人发射弹幕
func _fire_ranged() -> void:
	var targets := _get_targets()
	if targets.is_empty():
		return

	var target := targets[0]
	var player_pos := player_ref.global_position
	var direction := (target.global_position - player_pos).normalized()

	var count := weapon_data.base_projectile_count + _get_extra_projectiles()
	var spread_angle := deg_to_rad(15.0) if count > 1 else 0.0

	for i in count:
		var angle_offset := 0.0
		if count > 1:
			angle_offset = spread_angle * (i - (count - 1) / 2.0)

		var proj_dir := direction.rotated(angle_offset)
		var proj_data := _create_projectile_data()

		var scene_path := weapon_data.projectile_scene
		if scene_path == "":
			scene_path = "res://scenes/projectiles/projectile_default.tscn"

		projectile_pool_ref.get_projectile(scene_path, player_pos, proj_dir, proj_data, player_ref)


## 近战——范围内敌人直接造成伤害
func _fire_melee() -> void:
	var player_pos := player_ref.global_position
	var enemies := get_tree().get_nodes_in_group("enemies")

	for enemy in enemies:
		if enemy.has_method("is_alive") and not enemy.is_alive():
			continue
		var dist := player_pos.distance_to(enemy.global_position)
		if dist < weapon_data.base_range:
			var dmg := weapon_data.base_damage * _get_damage_mult()
			enemy.take_damage(dmg, player_ref)


## AOE——圆形范围伤害
func _fire_aoe() -> void:
	var player_pos := player_ref.global_position
	var enemies := get_tree().get_nodes_in_group("enemies")

	for enemy in enemies:
		if enemy.has_method("is_alive") and not enemy.is_alive():
			continue
		var dist := player_pos.distance_to(enemy.global_position)
		if dist < weapon_data.base_range:
			var dmg := weapon_data.base_damage * _get_damage_mult()
			enemy.take_damage(dmg, player_ref)


func _get_extra_projectiles() -> int:
	if player_ref and player_ref.has_method("get_stats"):
		return player_ref.get_stats().projectile_count
	return 0


func _get_extra_pierce() -> int:
	if player_ref and player_ref.has_method("get_stats"):
		return player_ref.get_stats().pierce
	return 0


## 组装弹幕数据，应用玩家属性修正
func _create_projectile_data() -> ProjectileData:
	var data := ProjectileData.new()
	data.speed = weapon_data.base_projectile_speed * _get_projectile_speed_mult()
	data.damage = weapon_data.base_damage * _get_damage_mult()
	data.pierce = weapon_data.base_pierce + _get_extra_pierce()
	data.lifetime = weapon_data.base_lifetime
	data.color = weapon_data.sprite_color
	data.scale = 1.0
	return data


func _get_projectile_speed_mult() -> float:
	if player_ref and player_ref.has_method("get_stats"):
		return player_ref.get_stats().projectile_speed
	return 1.0


## 供 UI 查询武器信息
func get_weapon_info() -> Dictionary:
	return {
		"name": weapon_data.weapon_name,
		"type": weapon_data.type,
		"tier": weapon_data.tier,
		"damage": weapon_data.base_damage,
		"attack_speed": weapon_data.base_attack_speed,
	}
