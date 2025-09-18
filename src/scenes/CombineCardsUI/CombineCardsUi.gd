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
    player_card_changed = false
    var event_card_name = %EventCard.get_resource().get_card_name()
    var player_card_name = %PlayerCard.get_resource().get_card_name()
    var resource = combo_mapping[event_card_name][player_card_name]
    %CombinedCard.init(resource, '')
    # %CombinedCard.set('disabled', false)

func _on_player_card_clicked(card_resource: CardResource):
  %PlayerCard.init(card_resource, '')
  player_card_changed = true

func _on_event_card_clicked(card_resource: CardResource):
  %EventCard.init(card_resource, '')
  event_card_changed = true
