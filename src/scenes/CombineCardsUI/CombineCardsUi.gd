extends CanvasLayer

@export var combo_mapping = {
  'event_rain': {
    'veg' = null,
    'bucket' = null,
  },
  'event_harvest': {
    'watered_veg' = null
  }
}

var combination_left: Card
var combination_right: Card

func process_combination():
  if null == combination_left || null == combination_right:
    return

  %NewCombinedCard.reset()
  var left_card_name = combination_left.get_resource().get_card_name()
  var right_card_name = combination_right.get_resource().get_card_name()

  if combo_mapping.has(left_card_name) and combo_mapping[left_card_name].has(right_card_name):
    var resource = combo_mapping[left_card_name][right_card_name]
    %NewCombinedCard.init(resource, '_on_newly_combined_card_pressed')


func _on_event_card_clicked(card: Card) -> void:
  %EventCard.init(card.get_resource(), '')
  combination_left = card
  process_combination()

func _on_player_card_clicked(card: Card) -> void:
  %PlayerCard.init(card.get_resource(), '')
  combination_right = card
  process_combination()

func _on_prepared_card_clicked(card: Card) -> void:
  if !%CombinedCard_1.is_init() && !%EventCard.is_init():
    %CombinedCard_1.init(card.get_resource(), '')
    combination_left = card
  elif !%CombinedCard_2.is_init():
    %CombinedCard_2.init(card.get_resource(), '')
    combination_right = card
  process_combination()


func reset_combination_slots() -> void:
  %PlayerCard.reset()
  %CombinedCard_1.reset()
  %EventCard.reset()
  %CombinedCard_2.reset()
  %NewCombinedCard.reset()
  combination_left = null
  combination_right = null

func _on_newly_combined_card_prepared(_card: Card) -> void:
  reset_combination_slots()

func _on_newly_combined_card_harvested_or_preserved(_card: Card) -> void:
  reset_combination_slots()
