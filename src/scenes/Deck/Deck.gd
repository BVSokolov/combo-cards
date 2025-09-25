class_name Deck extends Button

@export var deck: Array[DeckCard]
var current_game_deck: Array[CardResource] = []
var current_game_deck_changed: bool = false

func _ready() -> void:
  for deck_card in deck:
    var cards: Array[CardResource] = []
    cards.resize(deck_card.get_count())
    cards.fill(deck_card.get_card())
    current_game_deck.append_array(cards)
  # current_game_deck.shuffle()

func _process(_delta):
  if current_game_deck_changed && current_game_deck.size() <= 0:
    current_game_deck_changed = false
    set_empty()

func draw_card() -> CardResource:
  current_game_deck_changed = true
  return current_game_deck.pop_back()

func set_empty() -> void:
  set('disabled', true)

func is_empty() -> bool:
  return get('disabled')
