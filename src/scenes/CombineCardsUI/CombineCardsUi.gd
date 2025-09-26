extends CanvasLayer

var combo_mapping = {
  'event_rain': {
    'veg': WateredVeg.new(),
    'bucket': BucketOfWater.new(),
  },
  'event_sun': {
    'bucket_of_water': CombinedBucket.new(),
    'watered_veg': CombinedVeg.new(),
    'veg': SundriedVeg.new()
  },
  'event_bloom': {
    'watered_veg': MaturedVeg.new()
  },
  'event_preserve': {
    'jar_of_sundried_veg': Points.new(),
    'jar_of_sundried_veg_in_oil': Points.new(),
  },
  'event_harvest': {
    'matured_veg': Points.new(),
  },
  'bucket_of_water': {
    'veg': WateredVeg.new()
  },
  'sundried_veg': {
    'jar': JarOfSundriedVeg.new(),
  },
  'jar_of_sundried_veg': {
    'oil': JarOfSundriedVegInOil.new()
  }
}

var combination_left: Card
var combination_right: Card
var current_phase: TurnPhase.NAME = -1


func change_phase(phase: TurnPhase.NAME):
  current_phase = phase
  if current_phase != TurnPhase.NAME.COMBO:
    reset_combination_slots()

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
  if current_phase != TurnPhase.NAME.COMBO:
    return

  %EventCard.init(card.get_resource(), '')
  combination_left = card
  process_combination()

func _on_player_card_clicked(card: Card) -> void:
  if not [TurnPhase.NAME.COMBO, TurnPhase.NAME.COMBO_BONUS].has(current_phase):
    return

  %PlayerCard.init(card.get_resource(), '')
  combination_right = card
  process_combination()

func _on_prepared_card_clicked(card: Card) -> void:
  if not [TurnPhase.NAME.COMBO, TurnPhase.NAME.COMBO_BONUS].has(current_phase):
    return

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
