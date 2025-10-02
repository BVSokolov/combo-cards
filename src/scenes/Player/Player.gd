extends Control

signal end_phase
signal end_game

@onready var deck: Deck = %Deck
@onready var player_hand_nodes: Array[PlayerCard] = [%CardHand/CardSlot/Card, %CardHand/CardSlot_2/Card, %CardHand/CardSlot_3/Card, %CardHand/CardSlot_4/Card]
@onready var prepared_hand_nodes: Array[PlayerCard] = [%PreparedCards/CardSlot/Card, %PreparedCards/CardSlot_2/Card, %PreparedCards/CardSlot_3/Card, %PreparedCards/CardSlot_4/Card]

var player_card_listener_func_name: String = '_on_player_card_clicked'
var prepared_card_listener_func_name: String = '_on_prepared_card_clicked'
var card_prepared_listener_func_name: String = '_on_newly_combined_card_prepared'
var card_harvested_or_preserved_listener_func_name: String = '_on_newly_combined_card_harvested_or_preserved'

var current_phase: TurnPhase.NAME = -1

var cards_played: Array[PlayerCard]

func _ready():
	cards_played.resize(2)
	cards_played.fill(null)

func add_card_played(card: PlayerCard) -> void:
	cards_played.pop_back()
	cards_played.push_front(card)

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

func reset_cards_played() -> void:
	for card_played in cards_played:
		if null == card_played:
			return

		card_played.reset()
		if current_phase != TurnPhase.NAME.COMBO_BONUS:
			break
	cards_played.fill(null)

func _on_newly_combined_card_pressed(card: Card) -> void:
	var card_resource = card.get_resource()
  # if ['harvested_veg', 'preserved_veg'].has(card_resource.get_card_name()):

  #check if card was destroyed by hail
	if card_resource.get_card_name() == 'destroyed':
		reset_cards_played()
		print('card destroyed, end combo phase')
		end_phase.emit()
		return

  #check if card was cahsed in
	if ['points'].has(card_resource.get_card_name()):
		get_tree().call_group("CombinationListeners", card_harvested_or_preserved_listener_func_name, card)

		reset_cards_played()

		print('points cashed, end combo phase')
		end_phase.emit()
		return

  #check if we have space to prepare the card and do so
	for prepared_card in prepared_hand_nodes:
		if cards_played.has(prepared_card) or not prepared_card.is_init():
			reset_cards_played()
			prepared_card.init(card_resource, prepared_card_listener_func_name)
			get_tree().call_group("CombinationListeners", card_prepared_listener_func_name, card)

			print('combo card prepared, end combo phase')
			if current_phase == TurnPhase.NAME.COMBO:
				end_phase.emit()
			break


func _on_card_card_pressed(card: Card) -> void:
	add_card_played(card)
