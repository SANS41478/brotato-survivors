class_name WeaponManager
extends Node2D

## 武器管理器 — 管理6个武器槽

@export var max_slots: int = 6

var weapons: Array = []            # [WeaponBase, ...]
var weapon_slots: Array = []       # [WeaponData or null, ...]


func _ready() -> void:
	for i in max_slots:
		weapon_slots.append(null)


## 添加武器，返回分配的槽位号（-1 表示失败）
func add_weapon(data: WeaponData, player: Node2D, pool: ProjectilePool) -> int:
	# 检查是否有空槽
	var slot := -1
	for i in max_slots:
		if weapon_slots[i] == null:
			slot = i
			break

	if slot == -1:
		return -1  # 无空槽

	weapon_slots[slot] = data

	# 创建武器实例
	var weapon := WeaponBase.new()
	weapon.setup(data, player, pool)
	add_child(weapon)
	weapons.append(weapon)

	EventBus.weapon_added.emit(data, slot)
	return slot


## 移除武器，返回已移除的 WeaponData
func remove_weapon(slot: int) -> WeaponData:
	if slot < 0 or slot >= max_slots or weapon_slots[slot] == null:
		return null

	var data := weapon_slots[slot]
	weapon_slots[slot] = null

	# 移除武器实例
	for weapon in weapons:
		if weapon.weapon_data == data:
			weapon.queue_free()
			weapons.erase(weapon)
			break

	EventBus.weapon_removed.emit(data, slot)
	return data


func has_empty_slot() -> bool:
	for slot in weapon_slots:
		if slot == null:
			return true
	return false


func get_slot_count() -> int:
	var count := 0
	for slot in weapon_slots:
		if slot != null:
			count += 1
	return count
