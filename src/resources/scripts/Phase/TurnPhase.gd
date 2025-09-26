class_name TurnPhase extends Resource
enum NAME {PLAYER_DRAW, EVENT_DRAW, COMBO, COMBO_BONUS}

static func get_next(current: NAME) -> NAME:
  match current:
    NAME.PLAYER_DRAW:
      return NAME.EVENT_DRAW
    NAME.EVENT_DRAW:
      return NAME.COMBO
    NAME.COMBO:
      return NAME.COMBO_BONUS
    NAME.COMBO_BONUS:
      return NAME.PLAYER_DRAW
    _:
      return NAME.PLAYER_DRAW