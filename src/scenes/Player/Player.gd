extends CanvasLayer


@export var player_deck: Array[DeckCard]
@export var player_hand_size: int = 4
var current_game_deck: Array[Card] = []
var current_hand: Array[Card] = []

var current_hand_changed: bool = false
var current_game_deck_changed: bool = false

func _ready() -> void:
	for deck_card in player_deck:
		var cards: Array[Card] = []
		cards.resize(deck_card.get_count())
		cards.fill(deck_card.get_card())
		current_game_deck.append_array(cards)
	current_game_deck.shuffle()

func _process(_delta):
	if (current_hand_changed):
		current_hand_changed = false
		var card_slot = 0
		for card in current_hand:
			if card_slot == 0:
				$MarginContainer/HBoxContainer/PlayerArea/CardHandAndDeck/CardHand/CardSlot/Card/CardText.set_texture(card.get_texture())
				$MarginContainer/HBoxContainer/PlayerArea/CardHandAndDeck/CardHand/CardSlot/Card.show()
			if card_slot == 1:
				$MarginContainer/HBoxContainer/PlayerArea/CardHandAndDeck/CardHand/CardSlot_2/Card/CardText.set_texture(card.get_texture())
				$MarginContainer/HBoxContainer/PlayerArea/CardHandAndDeck/CardHand/CardSlot_2/Card.show()
			if card_slot == 2:
				$MarginContainer/HBoxContainer/PlayerArea/CardHandAndDeck/CardHand/CardSlot_3/Card/CardText.set_texture(card.get_texture())
				$MarginContainer/HBoxContainer/PlayerArea/CardHandAndDeck/CardHand/CardSlot_3/Card.show()
			if card_slot == 3:
				$MarginContainer/HBoxContainer/PlayerArea/CardHandAndDeck/CardHand/CardSlot_4/Card/CardText.set_texture(card.get_texture())
				$MarginContainer/HBoxContainer/PlayerArea/CardHandAndDeck/CardHand/CardSlot_4/Card.show()
			card_slot += 1

		if current_game_deck_changed && current_game_deck.size() <= 0:
			current_game_deck_changed = false
			$MarginContainer/HBoxContainer/PlayerArea/CardHandAndDeck/CardDeckSlot/Deck.set_empty()


func _on_deck_pressed() -> void:
	var card = current_game_deck.pop_back()
	current_hand.append(card)
	current_hand_changed = true
	current_game_deck_changed = true