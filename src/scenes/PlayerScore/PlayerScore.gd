extends CanvasLayer

var score = 0

func _on_newly_combined_card_harvested_or_preserved(_card: Card) -> void:
  score += 1
  %Score.text = str(score)