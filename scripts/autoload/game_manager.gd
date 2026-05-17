extends Node

## 游戏状态管理器 — 控制全局游戏流程

enum GameState {
	MAIN_MENU,
	CHARACTER_SELECT,
	BATTLE,
	LEVEL_UP,
	SHOP,
	GAME_OVER
}

var current_state: GameState = GameState.MAIN_MENU
var current_wave: int = 0
var selected_character_id: String = ""
var total_kills: int = 0
var total_gold: int = 0
var total_time: float = 0.0
var is_paused: bool = false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


func change_state(new_state: GameState) -> void:
	var previous_state := current_state
	current_state = new_state
	EventBus.game_state_changed.emit(new_state)
	_on_state_changed(previous_state, new_state)


func _on_state_changed(_from: GameState, to: GameState) -> void:
	match to:
		GameState.BATTLE:
			_start_battle()
		GameState.SHOP:
			_open_shop()
		GameState.LEVEL_UP:
			pass  # 升级是战斗中的暂停状态
		GameState.GAME_OVER:
			_handle_game_over()


func _start_battle() -> void:
	current_wave += 1
	EventBus.wave_started.emit(current_wave)


func _open_shop() -> void:
	pass  # 由 ShopSystem 处理


func _handle_game_over() -> void:
	var stats := {
		"waves": current_wave,
		"kills": total_kills,
		"gold": total_gold,
		"time": total_time,
		"character": selected_character_id
	}
	EventBus.player_died.emit(stats)


func reset_run() -> void:
	current_wave = 0
	total_kills = 0
	total_gold = 0
	total_time = 0.0
	is_paused = false
