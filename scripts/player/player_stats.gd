class_name PlayerStats
extends Resource

## 玩家属性数据 Resource

# --- 生命 ---
@export var max_hp: float = 100.0
@export var hp_regen: float = 0.0
@export var life_steal: float = 0.0        # 百分比 (0.0 = 0%)

# --- 伤害 ---
@export var damage: float = 1.0            # 全局伤害倍率
@export var melee_damage: float = 0.0      # 额外加成
@export var ranged_damage: float = 0.0
@export var elemental_damage: float = 0.0

# --- 攻击 ---
@export var attack_speed: float = 1.0      # 攻速倍率
@export var crit_chance: float = 0.05      # 5%
@export var crit_multiplier: float = 1.5
@export var attack_range: float = 1.0      # 范围倍率

# --- 弹幕 ---
@export var projectile_speed: float = 1.0
@export var projectile_count: int = 0      # 额外弹幕数
@export var pierce: int = 0                # 额外穿透数

# --- 移动 ---
@export var move_speed: float = 250.0

# --- 防御 ---
@export var armor: float = 0.0             # 减伤 %
@export var dodge: float = 0.0             # 闪避 %

# --- 辅助 ---
@export var pickup_range: float = 100.0
@export var exp_bonus: float = 1.0         # 经验倍率
@export var weapon_slots: int = 6


## 计算最终属性值（base_stats + modifiers）
func get_final_damage() -> float:
	return max(damage, 0.1)


func get_final_attack_speed() -> float:
	return max(attack_speed, 0.1)


func get_final_move_speed() -> float:
	return max(move_speed, 50.0)


func get_final_crit_chance() -> float:
	return clamp(crit_chance, 0.0, 1.0)


func get_damage_reduction() -> float:
	## 护甲减伤公式: reduction = armor / (armor + 100)
	if armor <= 0:
		return 0.0
	return armor / (armor + 100.0)
