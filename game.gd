class_name Game extends Node2D

enum GAME_STATES {PRETAROT, PLAYER_TURN_START, PLAYER_TURN, PLAYER_TURN_END, SPIRIT_TURN, UPGRADE, END}
enum DRAW_STATES {INITIAL_DRAW, TURN_DRAW, REDRAW, DRAW_X}

var GameState: GAME_STATES = GAME_STATES.PRETAROT
var DrawState: DRAW_STATES = DRAW_STATES.INITIAL_DRAW

var canDraw: bool = false
var drawXCount: int = 0

const MAX_CARDS = 1
const TURNS_TO_UPGRADE = 3
var turnsUntilUpgrade = TURNS_TO_UPGRADE
var card_count = 0
@onready var card_positions = [%CardPos1, %CardPos2, %CardPos3, %CardPos4, %CardPos5, %CardPos6]

var cards = []
var cards_played = []
var cards_played_past = []
var cards_played_present = []
var cards_played_future = []

var tarot_deck = ["death/tc_death.tscn", "fourofcups/tc_fourofcups.tscn",
	"theempress/tc_theempress.tscn", "thehangedman/tc_thehangedman.tscn", 
	"threeofswords/tc_threeofswords.tscn"]

var tarot_past
var tarot_present
var tarot_future

var tarot_drawn = false

var draw_cards = true
var card_hovered = false
var card_hovered_index = -1

var over_play_area = false

func _ready()->void:
	%PlayerSanity.text = "Sanity: " + str(%Player.sanity)
	%ProgressBar.value = %SpiritData.angerLevel
	%SadnessBar.value = %SpiritData.sadnessLevel
	if !tarot_drawn and GameState == GAME_STATES.PRETAROT:
		tarot_deck.shuffle()
		var pastString = tarot_deck.pop_front()
		print("past: ", pastString)
		print(tarot_deck.size())
		tarot_past = load("res://tarotcards/" + pastString).instantiate()
		tarot_past.startingPosition = %TarotPast.global_position
		
		var presentString = tarot_deck.pop_front()
		print("present: ", presentString)
		print(tarot_deck.size())
		tarot_present = load("res://tarotcards/" + presentString).instantiate()
		tarot_present.startingPosition = %TarotPresent.global_position
		
		var futureString = tarot_deck.pop_front()
		print("future: ", futureString)
		print(tarot_deck.size())
		tarot_future = load("res://tarotcards/" + futureString).instantiate()
		tarot_future.startingPosition = %TarotFuture.global_position
		
		%TarotCards.add_child(tarot_past)
		%TarotCards.add_child(tarot_present)
		%TarotCards.add_child(tarot_future)
		
		tarot_past.card.on_draw(%SpiritData)
		
		tarot_drawn = true
		GameState = GAME_STATES.SPIRIT_TURN
		SetPlayerTurn()

func onCardRelease(card)->void:
	var card_played = false
	if card.overlaps_area(%PlayArea):
		card_played = playCard(card)
	if !card_played:
		if card.overlaps_area(%TarotPast):
			card_played = playCardOnPast(card)
	if !card_played:
		if card.overlaps_area(%TarotPresent):
			card_played = playCardOnPresent(card)	
	if !card_played:
		if card.overlaps_area(%TarotFuture):
			card_played = playCardOnFuture(card)		
	if card_played:
		ReArrangeHand()

func playCard(card)->bool:
	var c_index = 0
	var c_found = false
	for i in cards.size():
		if cards[i] == card:
			print("Found card in hand")
			c_found = true
			c_index = i
	if c_found:
		cards.remove_at(c_index)
		cards_played.push_back(card)
		var nextPlayedPos: Vector2 = Vector2(%PlayAreaStart.global_position.x + (60 * cards_played.size()), %PlayAreaStart.global_position.y)
		card.setStartingPosition(nextPlayedPos)
		card.fortuneCard.on_play(%SpiritData, %Player, DrawXCards)
	return c_found
	
func playCardOnPast(card)->bool:
	var c_index = 0
	var c_found = false
	for i in cards.size():
		if cards[i] == card:
			print("Found card in hand")
			c_found = true
			c_index = i
	if c_found:
		var c = cards[c_index]
		cards.remove_at(c_index)
		cards_played_past.push_back(c)
		card.setStartingPosition(%PastStart.global_position)
		card.fortuneCard.on_play_past(%SpiritData, tarot_past.card, %Player)

	return c_found
	
func playCardOnPresent(card)->bool:
	var c_index = 0
	var c_found = false
	for i in cards.size():
		if cards[i] == card:
			print("Found card in hand")
			c_found = true
			c_index = i
	if c_found:
		var c = cards[c_index]
		cards.remove_at(c_index)
		cards_played_present.push_back(c)
		card.setStartingPosition(%PresentStart.global_position)
		card.fortuneCard.on_play_present(%SpiritData, tarot_past.card, %Player)

	return c_found
	
func playCardOnFuture(card)->bool:
	var c_index = 0
	var c_found = false
	for i in cards.size():
		if cards[i] == card:
			print("Found card in hand")
			c_found = true
			c_index = i
	if c_found:
		var c = cards[c_index]
		cards.remove_at(c_index)
		cards_played_future.push_back(c)
		card.setStartingPosition(%FutureStart.global_position)
		card.fortuneCard.on_play_future(%SpiritData, tarot_past.card, %Player)

	return c_found

func _process(delta: float) -> void:
	%PlayerSanity.text = "Sanity: " + str(%Player.sanity)
	%ProgressBar.value = %SpiritData.angerLevel
	%SadnessBar.value = %SpiritData.sadnessLevel
	card_hovered = false
	for index in cards.size():
		cards[index].setMoveLateral(false, 0, 0)
		if cards[index].hovering:
			card_hovered = true
			card_hovered_index = index
			
	if card_hovered:
		for index in cards.size():
			if index == card_hovered_index:
				continue
			var diff = index - card_hovered_index;
			var dir = 1
			if diff < 0:
				dir = -1
			cards[index].setMoveLateral(true, diff, dir)

func loadCard(pos: Vector2):
	var cardStrings = ["addanger/ft_addanger.tscn", 
	"addsadness/ft_addsadness.tscn",
	"drawthree/ft_draw_3_cards.tscn"]
	var randomCard = randi_range(0, cardStrings.size()-1)
	var cardString = "res://fortunecards/" + cardStrings[randomCard]
	print(cardString)
	var c: Node = load(cardString).instantiate()
	c.setStartingPosition(pos)
	%Cards.add_child(c)
	cards.append(c)
	# Card has been added to the scene, ready has been called. Can now call on_draw function
	c.fortuneCard.on_draw(%SpiritData, %Player)
	c.on_release.connect(onCardRelease)

func _on_timer_timeout() -> void:
	if !canDraw:
		return
		
	if DrawState == DRAW_STATES.INITIAL_DRAW or DrawState == DRAW_STATES.REDRAW:
		card_count = cards.size()
		if card_count < card_positions.size():
			var nextCardPosition: Vector2 = card_positions[card_count].global_position
			loadCard(nextCardPosition)
			card_count += 1
		else:
			canDraw = false
			DrawState = DRAW_STATES.TURN_DRAW
			
	if DrawState == DRAW_STATES.TURN_DRAW:
		card_count = cards.size()
		if card_count < card_positions.size():
			var nextCardPosition: Vector2 = card_positions[card_count].global_position
			loadCard(nextCardPosition)
		canDraw = false
		DrawState = DRAW_STATES.TURN_DRAW
		
	if DrawState == DRAW_STATES.DRAW_X:
		print("Draw x")
		card_count = cards.size()
		if card_count < card_positions.size() and drawXCount > 0:
			var nextCardPosition: Vector2 = card_positions[card_count].global_position
			loadCard(nextCardPosition)
			drawXCount -= 1
		else:
			canDraw = false
			DrawState = DRAW_STATES.TURN_DRAW

func _on_play_area_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	pass # Replace with function body.
	
func ChooseUpgrade()->void:
	%Upgrades.visible = true
	print(%Upgrades.visible)
	
func SetPlayerTurn()->void:
	if %Player.sanity <= 0:
		Reset()
	if GameState == GAME_STATES.SPIRIT_TURN:
		GameState = GAME_STATES.PLAYER_TURN_START
		# do things at start of turn
		for card in cards_played_past:
			card.fortuneCard.on_start_past(%SpiritData, tarot_past.card, %Player)
		for card in cards_played_present:
			card.fortuneCard.on_start_present(%SpiritData, tarot_past.card, %Player)
		for card in cards_played_future:
			card.fortuneCard.on_start_future(%SpiritData, tarot_past.card, %Player)
		SetPlayerTurn()
	elif GameState == GAME_STATES.PLAYER_TURN_START:
		GameState = GAME_STATES.PLAYER_TURN
		canDraw = true
		if DrawState == DRAW_STATES.INITIAL_DRAW:
			DrawHand()
		elif DrawState == DRAW_STATES.TURN_DRAW:
			DrawCard()
		%SpiritTurnTimer.stop()

func SetSpiritTurn()->void:
	GameState = GAME_STATES.SPIRIT_TURN
	canDraw = false
	%SpiritData.DamagePlayerSanity(%Player)
	%SpiritTurnTimer.start()
	%PlayerTurnOverlay.visible = true

func ReDraw()->void:
	for card in cards:
		card.queue_free()
	cards.clear()	
	card_count = 0
	DrawState = DRAW_STATES.REDRAW
	%Timer.start()
	
func DrawHand()->void:
	for card in cards:
		card.queue_free()
	cards.clear()	
	card_count = 0
	DrawState = DRAW_STATES.INITIAL_DRAW
	%Timer.start()
	
func DrawXCards(num: int)->void:
	print("Should Draw X Cards: ", num)
	canDraw = true
	DrawState = DRAW_STATES.DRAW_X
	drawXCount = num
	%Timer.start()
	
func DrawCard()->void:
	if cards.size() < MAX_CARDS-1:
		DrawState = DRAW_STATES.TURN_DRAW
		%Timer.start()

func EndTurn() -> void:
	if GameState == GAME_STATES.PLAYER_TURN:
		if %SpiritData.CheckThresholds():
			print("Game Won!")
		else:
			SetSpiritTurn()

func _on_end_turn_button_pressed() -> void:
	EndTurn()
	
func ReArrangeHand()->void:
	for i in cards.size():
		cards[i].setStartingPosition(card_positions[i].global_position)

func _on_upgrade_button_pressed() -> void:
	%Upgrades.visible = false
	SetPlayerTurn()

func _on_spirit_turn_timer_timeout() -> void:
	turnsUntilUpgrade -= 1
	%PlayerTurnOverlay.visible = false
	if turnsUntilUpgrade <= 0:
		ChooseUpgrade()
	else:
		SetPlayerTurn()
	turnsUntilUpgrade = TURNS_TO_UPGRADE
		
func Reset() -> void:
	# Clear cards
	for card in cards:
		card.queue_free()
	cards.clear()
	for card in cards_played:
		card.queue_free()
	cards_played.clear()
	for card in cards_played_past:
		card.queue_free()
	cards_played_past.clear()
	
	%Player.Reset()
	%SpiritData.Reset()
	GameState = GAME_STATES.PRETAROT
	DrawState = DRAW_STATES.INITIAL_DRAW
