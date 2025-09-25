extends CanvasLayer

var score = 0

signal end_phase
var current_phase: TurnPhase.NAME = -1

func _ready():
  %EndPhaseButton.set('disabled', true)

func change_phase(phase: TurnPhase.NAME):
  current_phase = phase
  if [TurnPhase.NAME.COMBO, TurnPhase.NAME.COMBO_BONUS].has(current_phase):
    %EndPhaseButton.set('disabled', false)
  else:
    %EndPhaseButton.set('disabled', true)

func _on_newly_combined_card_harvested_or_preserved(_card: Card) -> void:
  score += 1
  %Score.text = str(score)

func _on_end_phase_button_pressed() -> void:
  end_phase.emit()
