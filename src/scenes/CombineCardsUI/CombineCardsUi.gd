extends Control

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

var left_card: Card
var right_card: Card
var current_phase: TurnPhase.NAME = -1


func change_phase(phase: TurnPhase.NAME):
	current_phase = phase
	if current_phase != TurnPhase.NAME.COMBO:
		reset_combination_slots()

func process_combination():
	if null == left_card || null == right_card:
		return

	%NewCombinedCard.reset()
	var left_card_name = left_card.get_resource().get_card_name()
	var right_card_name = right_card.get_resource().get_card_name()

	if left_card_name == 'event_hail':
		var resource = Destroyed.new()
		%NewCombinedCard.init(resource, '_on_newly_combined_card_pressed')
	elif combo_mapping.has(left_card_name) and combo_mapping[left_card_name].has(right_card_name):
		var resource = combo_mapping[left_card_name][right_card_name]
		%NewCombinedCard.init(resource, '_on_newly_combined_card_pressed')


func _on_event_card_clicked(card: Card) -> void:
	if current_phase != TurnPhase.NAME.COMBO:
		return

	%LeftCard.init(card.get_resource(), '')
	left_card = card
	process_combination()

func _on_player_card_clicked(card: Card) -> void:
	if not [TurnPhase.NAME.COMBO, TurnPhase.NAME.COMBO_BONUS].has(current_phase):
		return

	%RightCard.init(card.get_resource(), '')
	right_card = card
	process_combination()

func _on_prepared_card_clicked(card: Card) -> void:
	if not [TurnPhase.NAME.COMBO, TurnPhase.NAME.COMBO_BONUS].has(current_phase):
		return

	if not %LeftCard.is_init():
		%LeftCard.init(card.get_resource(), '')
		left_card = card
	else:
		%RightCard.init(card.get_resource(), '')
		right_card = card
	process_combination()

func reset_combination_slots() -> void:
	%LeftCard.reset()
	%RightCard.reset()
	%NewCombinedCard.reset()

func reset_combination_slots_and_cards() -> void:
	reset_combination_slots()
	left_card = null
	right_card = null

func _on_newly_combined_card_prepared(_card: Card) -> void:
	reset_combination_slots_and_cards()

func _on_newly_combined_card_harvested_or_preserved(_card: Card) -> void:
	reset_combination_slots_and_cards()


func _on_left_card_card_pressed(_card: Card) -> void:
	if current_phase == TurnPhase.NAME.COMBO:
		return
	left_card = null
	%LeftCard.reset()

func _on_right_card_card_pressed(_card: Card) -> void:
	right_card = null
	%RightCard.reset()
