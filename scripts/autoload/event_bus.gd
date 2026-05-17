extends Node

## 全局信号总线
## 所有游戏事件通过此单例传递，实现模块解耦

# 游戏状态
signal game_state_changed(new_state: GameManager.GameState)

# 战斗
signal wave_started(wave: int)
signal wave_ended(wave: int, reward_gold: int)
signal enemy_killed(enemy: Node, position: Vector2, xp_value: int, gold_value: int)

# 玩家
signal player_health_changed(current: float, maximum: float)
signal player_damaged(amount: float, source: Node)
signal player_died(stats: Dictionary)

# 经验 & 升级
signal experience_changed(current: int, to_next: int)
signal level_up(new_level: int, options: Array)

# 经济
signal gold_changed(amount: int)

# 武器
signal weapon_added(weapon_data: Resource, slot: int)
signal weapon_removed(weapon_data: Resource, slot: int)
