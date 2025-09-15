extends CanvasLayer

@onready var deck_node: Deck = get_node('MarginContainer/DeckAndSlot/Deck')
@onready var card_node: Card = get_node('MarginContainer/DeckAndSlot/CardSlot/Card')

var current_event_card: CardResource
var current_event_changed: bool = false


func _process(_delta):
  pass


func _on_deck_pressed() -> void:
  var card = deck_node.draw_card()
  current_event_card = card
  card_node.set_content(current_event_card)
