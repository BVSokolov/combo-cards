class_name Card extends Button

signal card_pressed

var _card_resource: CardResource
var _listener_func_name: String = ''
var _is_init: bool = false
var _listener_func_args: Array = []

func init(resource: CardResource, func_name: String, func_args: Array = []) -> void:
	_card_resource = resource
	_listener_func_name = func_name
	_listener_func_args = func_args

	$CardFront.set_texture(_card_resource.get_texture())
	set('disabled', false)
	_is_init = true

func reset() -> void:
	_card_resource = null
	_listener_func_name = ''
	_listener_func_args = []

	$CardFront.set_texture(null)
	set('disabled', true)
	_is_init = false

func is_init() -> bool:
	return _is_init

func get_resource() -> CardResource:
	return _card_resource

func _on_pressed() -> void:
	card_pressed.emit(self)
	if _listener_func_name != '':
		if _listener_func_args.is_empty():
			get_tree().call_group("CardListeners", _listener_func_name, self)
		else:
			get_tree().call_group("CardListeners", _listener_func_name, self, _listener_func_args)

func _set_variant(variant_name: String) -> void:
	set_theme_type_variation(variant_name)

func set_variant_event() -> void:
	_set_variant('EventCard')

func set_variant_player() -> void:
	_set_variant('PlayerCard')

func set_variant_combined() -> void:
	_set_variant('CombinedCard')
