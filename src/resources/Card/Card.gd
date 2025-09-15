class_name CardResource extends Resource

var texture: Texture2D

func set_image(src: String):
  texture = ResourceLoader.load(src)

func get_texture() -> Texture2D:
  return texture
