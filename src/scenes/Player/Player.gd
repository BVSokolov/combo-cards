extends CanvasLayer

@onready var deck: Deck = get_node('MarginContainer/HBoxContainer/PlayerArea/CardHandAndDeck/CardDeckSlot/Deck')
@onready var player_hand_nodes = [%CardHand/CardSlot/Card, %CardHand/CardSlot_2/Card, %CardHand/CardSlot_3/Card, %CardHand/CardSlot_4/Card]
@onready var prepared_hand_nodes = [%PreparedCards/CardSlot/Card, %PreparedCards/CardSlot_2/Card, %PreparedCards/CardSlot_3/Card, %PreparedCards/CardSlot_4/Card]

var player_listener_func_name: String = '_on_player_card_clicked'
var prepared_listener_func_name: String = '_on_prepared_card_clicked'
var card_prepared_listener_func_name: String = '_on_newly_combined_card_prepared'
var card_harvested_or_preserved_listener_func_name: String = '_on_newly_combined_card_harvested_or_preserved'

var card_played: Card

func _process(_delta):
  pass

func _on_deck_pressed() -> void:
  var card_resource = deck.draw_card()
  for player_card in player_hand_nodes:
    if !player_card.is_init():
      player_card.init(card_resource, player_listener_func_name)
      break

func _on_newly_combined_card_pressed(card: Card) -> void:
  var card_resource = card.get_resource()
  # if ['harvested_veg', 'preserved_veg'].has(card_resource.get_card_name()):
  if ['points'].has(card_resource.get_card_name()):
    get_tree().call_group("CombinationListeners", card_harvested_or_preserved_listener_func_name, card)
    card_played.reset()
    return

  for prepared_card in prepared_hand_nodes:
    if !prepared_card.is_init():
      prepared_card.init(card_resource, prepared_listener_func_name)
      get_tree().call_group("CombinationListeners", card_prepared_listener_func_name, card)
      card_played.reset()
      break

func _on_card_card_pressed(card: Card) -> void:
  card_played = card
