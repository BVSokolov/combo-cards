extends CanvasLayer

signal end_phase

@export var listener_func_name: String = '_on_event_card_clicked'

var current_phase: TurnPhase.NAME = -1

func _process(_delta):
  pass

func change_phase(phase: TurnPhase.NAME):
  current_phase = phase
  if current_phase != TurnPhase.NAME.COMBO:
    %Card.reset()

func _on_deck_pressed() -> void:
  if not current_phase == TurnPhase.NAME.EVENT_DRAW:
    return

  if !%Card.is_init():
    var card_resource = %Deck.draw_card()
    %Card.init(card_resource, listener_func_name)
    print('card drawn, end event phase')
    end_phase.emit()
    get_tree().call_group('CardListeners', listener_func_name, %Card) # TODO: ew...

func _on_newly_combined_card_prepared(_card: Card) -> void:
  %Card.reset()

func _on_newly_combined_card_harvested_or_preserved(_card: Card) -> void:
  %Card.reset()
