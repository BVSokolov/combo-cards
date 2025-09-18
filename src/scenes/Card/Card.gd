class_name Card extends Button

var card_resource: CardResource
var listener_func_name: String = ''


func init(resource: CardResource, func_name: String):
  card_resource = resource
  listener_func_name = func_name

  $CardFront.set_texture(card_resource.get_texture())
  set('disabled', false)

func get_resource() -> CardResource:
  return card_resource


func _on_pressed() -> void:
  if listener_func_name != '':
    get_tree().call_group("CardListeners", listener_func_name, card_resource)