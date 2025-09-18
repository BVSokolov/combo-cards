extends CanvasLayer

@onready var deck: Deck = get_node('MarginContainer/HBoxContainer/PlayerArea/CardHandAndDeck/CardDeckSlot/Deck')

@export var listener_func_name: String = '_on_player_card_clicked'
@export var player_hand_size: int = 4
var current_hand: Array[CardResource] = []
var current_hand_changed: bool = false

func init_player_hand_card(card: Card, card_resource: CardResource):
  card.init(card_resource, listener_func_name)

func _process(_delta):
  if (current_hand_changed):
    current_hand_changed = false
    var card_slot = 0
    for card in current_hand:
      if card_slot == 0:
        init_player_hand_card(%CardSlot/Card, card)
      if card_slot == 1:
        init_player_hand_card(%CardSlot_2/Card, card)
      if card_slot == 2:
        init_player_hand_card(%CardSlot_3/Card, card)
      if card_slot == 3:
        init_player_hand_card(%CardSlot_4/Card, card)
      card_slot += 1

func _on_deck_pressed() -> void:
  var card = deck.draw_card()
  current_hand.append(card)
  current_hand_changed = true
