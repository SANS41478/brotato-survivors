extends Node

## 数据注册表 — 集中管理所有武器/敌人/角色/道具数据

## 在 _ready 中加载所有 .tres 资源文件

var weapons: Dictionary = {}       # weapon_id -> WeaponData
var enemies: Dictionary = {}       # enemy_id -> EnemyData
var characters: Dictionary = {}    # char_id -> CharacterData
var items: Dictionary = {}         # item_id -> ItemData


func _ready() -> void:
	_load_all_resources()


func _load_all_resources() -> void:
	_load_directory("res://resources/weapons/", weapons)
	_load_directory("res://resources/enemies/", enemies)
	_load_directory("res://resources/characters/", characters)
	_load_directory("res://resources/items/", items)


func _load_directory(path: String, target: Dictionary) -> void:
	var dir := DirAccess.open(path)
	if dir == null:
		return
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".tres"):
			var resource := load(path + file_name)
			if resource:
				target[file_name.trim_suffix(".tres")] = resource
		file_name = dir.get_next()
	dir.list_dir_end()


func get_weapon(id: String) -> Resource:
	return weapons.get(id, null)


func get_enemy(id: String) -> Resource:
	return enemies.get(id, null)


func get_character(id: String) -> Resource:
	return characters.get(id, null)


func get_item(id: String) -> Resource:
	return items.get(id, null)


func get_all_weapons() -> Array:
	var arr: Array = []
	arr.assign(weapons.values())
	return arr


func get_all_enemies() -> Array:
	var arr: Array = []
	arr.assign(enemies.values())
	return arr
