extends Control

var current_phase: TurnPhase.NAME = TurnPhase.NAME.PLAYER_DRAW

func _ready():
	%Player.change_phase(current_phase)

func change_phase(skip_count: int = 0):
	var next = TurnPhase.get_next(current_phase)
	while skip_count > 0:
		next = TurnPhase.get_next(next)
		skip_count -= 1
	current_phase = next
	var nodes = get_tree().get_nodes_in_group('TurnPhaseComponents')
	print('starting phase [draw, event, combo, combo bonus]', current_phase)
	for node in nodes:
		node.change_phase(current_phase)

func _on_player_end_phase() -> void:
	change_phase()


func _on_player_ui_end_phase() -> void:
	var skip_count = 0
	if current_phase == TurnPhase.NAME.COMBO:
		skip_count = 1
	change_phase(skip_count)


func _on_events_end_phase() -> void:
	change_phase()


func end_game() -> void:
	print('game ended, reloading main scene')

func _on_player_end_game() -> void:
	end_game()

func _on_events_end_game() -> void:
	end_game()
