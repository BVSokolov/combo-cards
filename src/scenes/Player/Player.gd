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

var card_played: PlayerCard
var current_phase: TurnPhase.NAME = -1

func _process(_delta):
  pass

func change_phase(phase: TurnPhase.NAME):
  current_phase = phase
  if current_phase == TurnPhase.NAME.PLAYER_DRAW:
      if deck.is_empty():
        print('deck exhausted, end game')
        end_game.emit()

func _on_deck_pressed() -> void:
  if current_phase != TurnPhase.NAME.PLAYER_DRAW:
    return
  
  for player_card in player_hand_nodes:
    if not player_card.is_init():
      var card_resource = deck.draw_card()
      player_card.init(card_resource, player_card_listener_func_name)
      break

  for player_card in player_hand_nodes:
    if not player_card.is_init():
      return
  print('player hand full, end draw phase')
  end_phase.emit()

func _on_newly_combined_card_pressed(card: Card) -> void:
  if card_played.get_slot_type() == CardSlot.TYPE.PREPARED:
    card_played.reset()
  
  var card_resource = card.get_resource()
  # if ['harvested_veg', 'preserved_veg'].has(card_resource.get_card_name()):
  if ['points'].has(card_resource.get_card_name()):
    get_tree().call_group("CombinationListeners", card_harvested_or_preserved_listener_func_name, card)
    card_played.reset()
    print('points cashed, end combo phase')
    end_phase.emit()

  for prepared_card in prepared_hand_nodes:
    if not prepared_card.is_init():
      prepared_card.init(card_resource, prepared_card_listener_func_name)
      get_tree().call_group("CombinationListeners", card_prepared_listener_func_name, card)
      card_played.reset()
      print('combo card prepared, end combo phase')
      end_phase.emit()
      break

func _on_card_card_pressed(card: Card) -> void:
  card_played = card
