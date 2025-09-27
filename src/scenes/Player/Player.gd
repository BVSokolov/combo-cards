extends CanvasLayer

signal end_phase
signal end_game

@onready var deck: Deck = get_node('MarginContainer/HBoxContainer/PlayerArea/CardHandAndDeck/CardDeckSlot/Deck')
@onready var player_hand_nodes: Array[PlayerCard] = [%CardHand/CardSlot/Card, %CardHand/CardSlot_2/Card, %CardHand/CardSlot_3/Card, %CardHand/CardSlot_4/Card]
@onready var prepared_hand_nodes: Array[PlayerCard] = [%PreparedCards/CardSlot/Card, %PreparedCards/CardSlot_2/Card, %PreparedCards/CardSlot_3/Card, %PreparedCards/CardSlot_4/Card]

var player_card_listener_func_name: String = '_on_player_card_clicked'
var prepared_card_listener_func_name: String = '_on_prepared_card_clicked'
var card_prepared_listener_func_name: String = '_on_newly_combined_card_prepared'
var card_harvested_or_preserved_listener_func_name: String = '_on_newly_combined_card_harvested_or_preserved'

var current_phase: TurnPhase.NAME = -1

var cards_played: Dictionary = {}

func _process(_delta):
  pass

func is_hand_full() -> bool:
  for player_card in player_hand_nodes:
    if not player_card.is_init():
      return false
  return true

func change_phase(phase: TurnPhase.NAME):
  current_phase = phase
  if current_phase == TurnPhase.NAME.PLAYER_DRAW:
      if is_hand_full():
        print('player hand full, end draw phase')
        end_phase.emit()
      elif deck.is_current_deck_empty():
        print('player deck exhausted, end game')
        end_game.emit()

func _on_deck_pressed() -> void:
  if current_phase != TurnPhase.NAME.PLAYER_DRAW:
    return
  
  for player_card in player_hand_nodes:
    if not player_card.is_init():
      var card_resource = deck.draw_card()
      player_card.init(card_resource, player_card_listener_func_name)
      break
  
  if is_hand_full():
        print('player hand full, end draw phase')
        end_phase.emit()

func _on_newly_combined_card_pressed(card: Card) -> void:
  var card_resource = card.get_resource()
  # if ['harvested_veg', 'preserved_veg'].has(card_resource.get_card_name()):
  if ['points'].has(card_resource.get_card_name()):
    get_tree().call_group("CombinationListeners", card_harvested_or_preserved_listener_func_name, card)

    for card_played in cards_played.values():
      card_played.reset()
    cards_played.clear()

    print('points cashed, end combo phase')
    end_phase.emit()
    return

  for prepared_card in prepared_hand_nodes:
    if cards_played.values().has(prepared_card) or not prepared_card.is_init():
      prepared_card.init(card_resource, prepared_card_listener_func_name)
      get_tree().call_group("CombinationListeners", card_prepared_listener_func_name, card)
      
      for card_played in cards_played.values():
        if card_played.get_instance_id() != prepared_card.get_instance_id():
          card_played.reset()
      cards_played.clear()
      print('combo card prepared, end combo phase')
      if current_phase == TurnPhase.NAME.COMBO:
        end_phase.emit()
      break


func _on_card_card_pressed(card: Card) -> void:
  cards_played[card.get_instance_id()] = card
