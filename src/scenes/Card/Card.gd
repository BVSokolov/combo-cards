class_name Card extends Button

func set_content(card_resource: CardResource):
  $CardFront.set_texture(card_resource.get_texture())
  set('disabled', false)