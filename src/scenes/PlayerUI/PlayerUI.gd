extends Control

var score = 0

signal end_phase
var current_phase: TurnPhase.NAME = -1

func _ready():
	%EndPhaseButton.set('disabled', true)
	%NotificationContainer.hide()

func change_phase(phase: TurnPhase.NAME):
	current_phase = phase

	%PhaseNameLabel.text = str(TurnPhase.DISPLAY_NAME[current_phase])
	%AnimationPlayer.play('phase_changed')
	%NotificationContainer.show()

	if [TurnPhase.NAME.COMBO, TurnPhase.NAME.COMBO_BONUS].has(current_phase):
		%EndPhaseButton.set('disabled', false)
	else:
		%EndPhaseButton.set('disabled', true)

func _on_newly_combined_card_harvested_or_preserved(_card: Card) -> void:
	score += 1
	%Score.text = str(score)

func _on_end_phase_button_pressed() -> void:
	end_phase.emit()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	%NotificationContainer.hide()
