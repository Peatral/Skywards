extends Node

var RichPresence
onready var GodotRichPresence = load("res://bin/librichpresence.gdns")

var state = "Lobby"
onready var startTimestamp = OS.get_unix_time()
onready var joinSecret = ""

var shutdown = false

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		shutdown()

func _ready():
	get_tree().set_auto_accept_quit(false)
	
	RichPresence = GodotRichPresence.new()
	
	# SIGNALS
	RichPresence.connect("ready", self, "onRichPresenceReady")
	RichPresence.connect("disconnected", self, "onRichPresenceDisconnected")
	RichPresence.connect("error", self, "onRichPresenceError")
	RichPresence.connect("join_game", self, "onRichPresenceJoinGame")
	RichPresence.connect("join_request", self, "onRichPresenceJoinRequest")
	RichPresence.connect("spectate_game", self, "onRichPresenceSpectateGame")
	
	initialize()
	update_richpresence()

func initialize():
	RichPresence.init({
		"app_id": "587927307847598090"
	})

func update_richpresence():
	RichPresence.update({
		"state": state,
		"details": "Nah, don't read this",
		"large_image_key": "logo",
		"large_image_text ": "Yeah, I made this hell...",
		"party_id" : "ab488379-c51d-4a4v-ad32-2b9n01c91657",
		"party_size" : gamestate.players.size(),
		"party_max" : gamestate.MAX_PEERS,
		#"spectate_secret" : "MTIzNDV8MTIzNDV8MTMyNDU0",
		"join_secret" : joinSecret,#decrypted data to get match (ip+port etc?)
		"start_timestamp" : startTimestamp,
	})

func onRichPresenceReady(user):
	print(" ======= READY ======= ")
	print("USERID: ", user["user_id"])
	print("USERNAME: ", user["username"])
	print("DISCRIMINATOR: ", user["discriminator"])
	print("AVATAR: ", user["avatar"])
	
	gamestate.player_name = user["username"]
	$Anim.play("RPC Ready")

func onRichPresenceDisconnected(code, message):
	print(" ======= DISCONNECTED ======= ")
	print("CODE: " + str(code))
	print("MESSAGE: " + message)
	
func onRichPresenceError(code, message):
	print(" ======= ERROR ======= ")
	print("CODE: " + str(code))
	print("MESSAGE: " + message)
	update_richpresence()

func onRichPresenceJoinGame(secret):
	print(" ======= JOIN GAME ======= ")
	print("SECRET :", secret)
	
	gamestate.join_game(secret, gamestate.player_name)

func onRichPresenceJoinRequest(requestUser):
	print("======= JOIN REQUEST ======= ")
	print("USERID: ", requestUser["user_id"])
	print("USERNAME: ", requestUser["username"])
	print("DISCRIMINATOR: ", requestUser["discriminator"])
	print("AVATAR: ", requestUser["avatar"])

func onRichPresenceSpectateGame(secret):
	print(" ======= SPECTATE GAME ======= ")
	print("SECRET: ", secret)

func run_callbacks():
	if !shutdown:
		update_richpresence()
		RichPresence.run_callbacks()
	else:
		get_tree().quit()

func shutdown():
	gamestate.end_game()
	RichPresence.shutdown()
	print("game shutdown")
	shutdown = true
	$Timer.wait_time = 3
	$Timer.start()