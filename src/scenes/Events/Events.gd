extends CanvasLayer

@onready var deck_node: Deck = get_node('MarginContainer/DeckAndSlot/Deck')
@onready var card_node: Card = get_node('MarginContainer/DeckAndSlot/CardSlot/Card')

@export var listener_func_name: String = '_on_event_card_clicked'

func _process(_delta):
  pass

func _on_deck_pressed() -> void:
  var card_resource = deck_node.draw_card()
  card_node.init(card_resource, listener_func_name)

func _on_newly_cobined_card_prepared(_card: Card) -> void:
  card_node.reset()