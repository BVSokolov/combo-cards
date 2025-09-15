extends CanvasLayer

@onready var deck: Deck = get_node('MarginContainer/HBoxContainer/PlayerArea/CardHandAndDeck/CardDeckSlot/Deck')

@export var player_hand_size: int = 4
var current_hand: Array[CardResource] = []
var current_hand_changed: bool = false


func _process(_delta):
  if (current_hand_changed):
    current_hand_changed = false
    var card_slot = 0
    for card in current_hand:
      if card_slot == 0:
        $MarginContainer/HBoxContainer/PlayerArea/CardHandAndDeck/CardHand/CardSlot/Card.set_content(card)
      if card_slot == 1:
        $MarginContainer/HBoxContainer/PlayerArea/CardHandAndDeck/CardHand/CardSlot_2/Card.set_content(card)
      if card_slot == 2:
        $MarginContainer/HBoxContainer/PlayerArea/CardHandAndDeck/CardHand/CardSlot_3/Card.set_content(card)
      if card_slot == 3:
        $MarginContainer/HBoxContainer/PlayerArea/CardHandAndDeck/CardHand/CardSlot_4/Card.set_content(card)
      card_slot += 1

func _on_deck_pressed() -> void:
  var card = deck.draw_card()
  current_hand.append(card)
  current_hand_changed = true
