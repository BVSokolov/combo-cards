class_name Card extends Button

signal card_pressed

var __card_resource: CardResource
var __listener_func_name: String = ''
var __is_init: bool = false


# func init(resource: CardResource, func_name: String, func_args: Array) -> void:
func init(resource: CardResource, func_name: String) -> void:
	__card_resource = resource
	__listener_func_name = func_name

	$CardFront.set_texture(__card_resource.get_texture())
	set('disabled', false)
	__is_init = true

func reset() -> void:
	__card_resource = null
	__listener_func_name = ''

	$CardFront.set_texture(null)
	set('disabled', true)
	__is_init = false

func is_init() -> bool:
	return __is_init

func get_resource() -> CardResource:
	return __card_resource

func _on_pressed() -> void:
	card_pressed.emit(self)
	if __listener_func_name != '':
		get_tree().call_group("CardListeners", __listener_func_name, self)
