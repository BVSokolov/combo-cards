extends CanvasLayer

@export var combo_mapping = {
  'event_rain': {
    'veg' = null,
    'bucket' = null,
  }
}


var event_card_changed = false
var player_card_changed = false

func _process(_delta):
  if (event_card_changed && player_card_changed):
    %CombinedCard.reset()
    player_card_changed = false
    var event_card_name = %EventCard.get_resource().get_card_name()
    var player_card_name = %PlayerCard.get_resource().get_card_name()
    if combo_mapping.has(event_card_name) and combo_mapping[event_card_name].has(player_card_name):
      var resource = combo_mapping[event_card_name][player_card_name]
      %CombinedCard.init(resource, '_on_newly_combined_card_pressed')
    # %CombinedCard.set('disabled', false)

func _on_player_card_clicked(card: Card) -> void:
  %PlayerCard.init(card.get_resource(), '')
  player_card_changed = true

func _on_event_card_clicked(card: Card) -> void:
  %EventCard.init(card.get_resource(), '')
  event_card_changed = true

func _on_newly_cobined_card_prepared(_card: Card) -> void:
  %PlayerCard.reset()
  %EventCard.reset()
  %CombinedCard.reset()
