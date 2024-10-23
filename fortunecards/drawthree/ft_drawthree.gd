extends FortuneCard

func _init() -> void:
	cost = 2

func on_draw(spirit: SpiritData, player: Player)->void:
	pass

func on_play(spirit: SpiritData, player: Player, callable: Callable)->void:
	player.DrainSanity(cost)
	# draw 3 cards
	callable.call(3)
