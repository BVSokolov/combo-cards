class_name Deck extends Button

var empty_deck_material = preload("res://src/resources/shaders/materials/empty_deck_material.tres")

@export var deck: Array[DeckCard]

var current_game_deck: Array[CardResource] = []
var shuffle_count: int = 5

func _ready() -> void:
  for deck_card in deck:
    var cards: Array[CardResource] = []
    cards.resize(deck_card.get_count())
    cards.fill(deck_card.get_card())
    current_game_deck.append_array(cards)
  
  var count = shuffle_count
  while count > 0:
    current_game_deck.shuffle()
    count -= 1

func draw_card() -> CardResource:
  var card = current_game_deck.pop_back()
  if is_current_deck_empty():
    set_empty()
  return card

func set_empty() -> void:
  set("material", empty_deck_material)

func is_current_deck_empty() -> bool:
  return current_game_deck.is_empty()
