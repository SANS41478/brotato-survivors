extends Node

## 音频管理器（MVP 阶段占位，后续填充）

var music_player: AudioStreamPlayer
var sfx_player: AudioStreamPlayer


func _ready() -> void:
	music_player = AudioStreamPlayer.new()
	sfx_player = AudioStreamPlayer.new()
	add_child(music_player)
	add_child(sfx_player)


func play_music(stream: AudioStream, volume_db: float = 0.0) -> void:
	if music_player.playing:
		music_player.stop()
	music_player.stream = stream
	music_player.volume_db = volume_db
	music_player.play()


func play_sfx(stream: AudioStream, volume_db: float = 0.0) -> void:
	sfx_player.stream = stream
	sfx_player.volume_db = volume_db
	sfx_player.play()


func stop_music() -> void:
	music_player.stop()
