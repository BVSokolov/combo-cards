extends Control

var current_phase: TurnPhase.NAME = TurnPhase.NAME.PLAYER_DRAW

func _ready():
  %Player.change_phase(current_phase)

func change_phase():
  var next = TurnPhase.get_next(current_phase)
  current_phase = next
  var nodes = get_tree().get_nodes_in_group('TurnPhaseComponents')
  print('starting phase [draw, event, combo, combo bonus]', next)
  for node in nodes:
    node.change_phase(current_phase)

func _on_player_end_phase() -> void:
  change_phase()


func _on_player_ui_end_phase() -> void:
  change_phase()


func _on_events_end_phase() -> void:
  change_phase()
