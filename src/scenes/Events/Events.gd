extends CanvasLayer

@export var listener_func_name: String = '_on_event_card_clicked'

func _process(_delta):
  pass

func _on_deck_pressed() -> void:
  var card_resource = %Deck.draw_card()
  %Card.init(card_resource, listener_func_name)

func _on_newly_combined_card_prepared(_card: Card) -> void:
  %Card.reset()

func _on_newly_combined_card_harvested_or_preserved(_card: Card) -> void:
  %Card.reset()
