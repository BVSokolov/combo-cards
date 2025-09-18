extends CanvasLayer

@onready var deck_node: Deck = get_node('MarginContainer/DeckAndSlot/Deck')
@onready var card_node: Card = get_node('MarginContainer/DeckAndSlot/CardSlot/Card')

@export var listener_func_name: String = '_on_event_card_clicked'

var current_event_card: CardResource
var current_event_changed: bool = false


func _process(_delta):
  pass


func _on_deck_pressed() -> void:
  var card = deck_node.draw_card()
  current_event_card = card
  card_node.init(current_event_card, listener_func_name)
