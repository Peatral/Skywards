extends Node

onready var GodotRichPresence = load("res://bin/librichpresence.gdns")
onready var RichPresence = GodotRichPresence.new()


var state = "Lobby"
var user_id = 0

onready var startTimestamp = OS.get_unix_time()
onready var joinSecret = ""

onready var request = HTTPRequest.new()

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		shutdown()

func _ready():
	get_tree().set_auto_accept_quit(false)
	
	add_child(request)
	# SIGNALS
	RichPresence.connect("ready", self, "onRichPresenceReady")
	RichPresence.connect("disconnected", self, "onRichPresenceDisconnected")
	RichPresence.connect("error", self, "onRichPresenceError")
	RichPresence.connect("join_game", self, "onRichPresenceJoinGame")
	RichPresence.connect("join_request", self, "onRichPresenceJoinRequest")
	RichPresence.connect("spectate_game", self, "onRichPresenceSpectateGame")
	
	request.connect("request_completed", self, "on_request_completed")
	
	initialize()
	update_richpresence()

func requestAvatar(id, avatar):
	request.download_file = str(id) + ".png"
	request.request("https://cdn.discordapp.com/avatars/"+str(id)+"/"+str(avatar)+".png")

func on_request_completed(result, response_code, headers, body):
	get_node("/root/lobby/avatar").set_texture(load(str(user_id) + ".png"))

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
	
	user_id = user["user_id"]
	requestAvatar(user["user_id"], user["avatar"])

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
	
	RichPresence.reply(1)

func onRichPresenceSpectateGame(secret):
	print(" ======= SPECTATE GAME ======= ")
	print("SECRET: ", secret)

func run_callbacks():
	update_richpresence()
	RichPresence.run_callbacks()

func shutdown():
	gamestate.end_game()
	RichPresence.shutdown()
	get_tree().call_deferred("quit")