class_name WeaponData
extends Resource

## 武器数据 Resource — 定义武器的所有属性

enum WeaponType { MELEE, RANGED, AOE, SUMMON, BEAM }
enum Targeting { NEAREST, RANDOM, WEAKEST, STRONGEST, SELF }

@export var weapon_id: String = ""
@export var weapon_name: String = "Unknown Weapon"
@export var type: WeaponType = WeaponType.RANGED
@export var targeting: Targeting = Targeting.NEAREST

@export var base_damage: float = 10.0
@export var base_attack_speed: float = 1.0   # 每秒攻击次数
@export var base_range: float = 200.0
@export var base_projectile_speed: float = 300.0
@export var base_projectile_count: int = 1
@export var base_pierce: int = 0
@export var base_lifetime: float = 2.0

@export var tier: int = 1                     # 1-4
@export var projectile_scene: String = ""     # res://路径
@export var sprite_color: Color = Color.WHITE
@export var description: String = ""
