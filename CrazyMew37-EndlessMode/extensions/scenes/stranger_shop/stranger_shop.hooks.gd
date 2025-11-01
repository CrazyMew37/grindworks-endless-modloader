extends Object

# let's do something goofy -cm37
const OPENER_LINES_6 := [
	"Welcome back. Got anythin interestin' to trade?",
	"Usually, your kind only visits my place once.",
	"I've restocked, as you can see.",
	"Got somethin' more interestin' this time?",
	"I got more junk for a bargain. Don't worry, it's good junk.",
	"Wonder if you're tryin' to find the foreman?"
]

const OPENER_LINES_11 := [
	"It's you again.",
	"Guess you're startin' to become a regular. I got quality stuff, as usual.",
	"There's a lot of stuff you missed that makes great product.",
	"Those cogs are gettin' pretty strong, hm?",
	"Don't worry, I've got stuff to trade for days.",
	"I'd watch out for those Dragon Kings if I were you.",
]

const OPENER_LINES_21 := [
	"Are you lost, or somethin'? Usually, people like you leave by now.",
	"What'll it be this time?",
	"You know, not many cogs come here. Not that I want em' here, anyway.",
	"How do you store all of your stuff? Whatever, feel free to pull somethin' out.",
	"You've been hordin' a lot of those sugary beans. Too bad I have no use for 'em.",
	"You got plenty of stuff, it seems. Care to drop some here?",
]

const OPENER_LINES_41 := [
	"You keep comin' back. Plan to make this your new home?",
	"I'm pretty sure I've seen several Toons meet the Directors during your whole time here.",
	"I've bet you met plenty of Crazy Cogs, huh? Heard some come from other worlds.",
	"At this point, I'm pretty sure you're steamrollin' those cogs, hm?",
	"Here for tradin', again? You're feedin' my buisness pretty well.",
	"Still at it? Surprsied you aren't tired at this point.",
]

const OPENER_LINES_81 := [
	"You know, if you want to be my roomie, I got plenty of space here.",
	"I'm pretty sure with your collection, you could be pretty mean competitor for me.",
	"Let me guess, you're gonna be tradin' some of the same old same old?",
	"Exhausted? Feel free to stay here for a break, maybe even trade some stuff?",
	"You're really determined to keep goin', huh? Well, I got some stuff for you.",
	"You know, I've lost count of how many times you've visited. What'll it be?",
]

const GOODBYE_LINES_6 := [
	"Don't be a stranger.",
	"Come again, pal.",
	"Pleasure doing business with you.",
	"Thanks for stopping by.",
	"Tell your friends to come around.",
	"If you got anythin' else to donate, you know where to go.",
	"Exit's out back.",
]

const GOODBYE_LINES_11 := [
	"Don't be a stranger.",
	"Come again, pal.",
	"Pleasure doing business with you.",
	"Thanks for stopping by.",
	"Good luck with whatever you're tryin' to accomplish.",
	"Tell your friends to come around.",
	"If you got anythin' else to donate, you know where to go.",
	"Exit's out back.",
]

const GOODBYE_LINES_21 := [
	"Don't be a stranger.",
	"Come again, pal.",
	"Pleasure doing business with you.",
	"Thanks for stopping by.",
	"Tell your friends to come around.",
	"If you got anythin' else to donate, you know where to go.",
	"You know where to exit.",
	"If you need to leave, I'd meet up with those directors. They got an elevator straight to the surface.",
]

const GOODBYE_LINES_41 := [
	"Don't be a stranger.",
	"I hope you know there's no point to this anymore.",
	"Pleasure doing business with you.",
	"Thanks for stopping by.",
	"Tell your friends to come around.",
	"If you got anythin' else to donate, you know where to go.",
	"You know where to exit.",
	"If you need to leave, I'd meet up with those directors. They got an elevator straight to the surface.",
	"Ya know, we'd make a good buisness together.",
	"Feel free to stay for a while longer. Or not.",
]

const GOODBYE_LINES_81 := [
	"Don't be a stranger.",
	"I hope you know there's no point to this anymore.",
	"Pleasure doing business with you.",
	"Thanks for stopping by.",
	"Tell your friends to come around.",
	"I would just quit now if I were you.",
	"If you got anythin' else to donate, you know where to go.",
	"You know where to exit.",
	"If you need to leave, I'd meet up with those directors. They got an elevator straight to the surface.",
	"Ya know, we'd make a good buisness together.",
	"Feel free to stay for a while longer. Or not.",
	"I hope you plan to stop soon.",
	"I'd stop wastin' your time if I were you.",
	"I hope you know they'll just rebuild those cogs you keep defeatin'.",
	"It's time to quit, pal.",
]

func get_random_opener_line(chain: ModLoaderHookChain) -> String:
	if Util.floor_number < 6:
		return chain.reference_object.OPENER_LINES.pick_random()
	elif Util.floor_number > 5 && Util.floor_number < 11:
		return OPENER_LINES_6.pick_random()
	elif Util.floor_number > 10 && Util.floor_number < 21:
		return OPENER_LINES_11.pick_random()
	elif Util.floor_number > 20 && Util.floor_number < 41:
		return OPENER_LINES_21.pick_random()
	elif Util.floor_number > 40 && Util.floor_number < 81:
		return OPENER_LINES_41.pick_random()
	else:
		return OPENER_LINES_81.pick_random()

func run_shop_exit(chain: ModLoaderHookChain) -> void:
	if Util.floor_number < 6:
		chain.reference_object.stranger.speak(chain.reference_object.GOODBYE_LINES.pick_random())
	elif Util.floor_number > 5 && Util.floor_number < 11:
		chain.reference_object.stranger.speak(GOODBYE_LINES_6.pick_random())
	elif Util.floor_number > 10 && Util.floor_number < 21:
		chain.reference_object.stranger.speak(GOODBYE_LINES_11.pick_random())
	elif Util.floor_number > 20 && Util.floor_number < 41:
		chain.reference_object.stranger.speak(GOODBYE_LINES_21.pick_random())
	elif Util.floor_number > 40 && Util.floor_number < 81:
		chain.reference_object.stranger.speak(GOODBYE_LINES_41.pick_random())
	else:
		chain.reference_object.stranger.speak(GOODBYE_LINES_81.pick_random())

	if chain.reference_object.stranger.stranger_model.animator.animation_finished.is_connected(chain.reference_object.on_stranger_intro_finished):
		chain.reference_object.stranger.stranger_model.animator.animation_finished.disconnect(chain.reference_object.on_stranger_intro_finished)
	chain.reference_object.ui.hide()
	chain.reference_object.stranger.set_stranger_active(false)
	var transition_time := 1.0
	var movie = chain.reference_object.start_shop_tween()
	movie.tween_callback(CameraTransition.from_current.bind(chain.reference_object.player, chain.reference_object.player.camera.camera, transition_time))
	movie.tween_interval(transition_time)
	movie.finished.connect(
		func():
			chain.reference_object.player.state = Player.PlayerState.WALK
	)
	
