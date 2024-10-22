class_name FortuneCard extends Node

var cost: int
func _ready()->void:
	pass

func on_draw(spirit: SpiritData, player: Player)->void:
	pass

# On Play in General Area
func on_play(spirit: SpiritData, player: Player, callable: Callable)->void:
	pass

# Fortune Card On Play on Tarot
func on_play_past(spirit: SpiritData, tarotCard: TarotCard, player: Player)->void:
	pass

func on_play_present(spirit: SpiritData, tarotCard: TarotCard, player: Player)->void:
	pass

func on_play_future(spirit: SpiritData, tarotCard: TarotCard, player: Player)->void:
	pass

# Fortune Card On Start functions
func on_start_past(spirit: SpiritData, tarotCard: TarotCard, player: Player) -> void:
	pass

func on_start_present(spirit: SpiritData, tarotCard: TarotCard, player: Player) -> void:
	pass

func on_start_future(spirit: SpiritData, tarotCard: TarotCard, player: Player) -> void:
	pass
