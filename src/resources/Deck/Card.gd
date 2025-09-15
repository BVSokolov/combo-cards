class_name DeckCard extends Resource

@export var card: Card
@export var count: int

func get_card() -> Card:
  return card

func get_count() -> int:
  return count