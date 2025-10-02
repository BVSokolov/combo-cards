class_name CardResource extends Resource

var texture: Texture2D
var name: String

func init(src: String, card_name: String):
  name = card_name
  set_texture(src)

func set_texture(src: String):
  texture = ResourceLoader.load(src)

func get_texture() -> Texture2D:
  return texture

func get_card_name() -> String:
  return name