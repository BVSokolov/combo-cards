class_name DeckCard extends Resource

@export var card: CardResource
@export var count: int

func get_card() -> CardResource:
  return card

func get_count() -> int:
  return count