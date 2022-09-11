extends Spatial

var players = {};

var EscMenu = {
	enabled = false,
	node = null
};

var map_info = {};

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);

	get_tree().connect("connected_to_server", self, "_connected_to_server");
	get_tree().connect("connection_failed", self, "_connection_failed");
	get_tree().connect("server_disconnected", self, "_server_disconnected");

func _connected_to_server():
	print("Successfully connected to server.");

	var s_packet = {
		client_id = get_tree().get_network_unique_id(),
		player = $'/root/PlayerInfo'.player
	};

	rpc_id(1, "_register_player", s_packet);

func _connection_failed():
	print("Failed to connect to server.");

func _server_disconnected():
	get_tree().change_scene("res://Scenes/GUI/MainMenu.tscn");

func _process(delta):
	if(Input.is_action_just_pressed("restart")):
		get_tree().reload_current_scene();

	if(Input.is_action_just_pressed("fullscreen")):
		OS.set_window_fullscreen(true);

# Spawn a player in current world
func create_player_node(client_id, position, add_to_world=true):
	print("CREATING CLIENT_ID'S PLAYER NODE =====> ", client_id);

	var player_node = preload("res://play/player/Player.tscn").instance();
	player_node.set_name(str(client_id));
	player_node.set_network_master(client_id);
	player_node.translate(position);

	var nametag_node = Label.new();
	nametag_node.set_name(str(client_id));
	nametag_node.text = players[client_id].display_name;

	$'/root/Root/World/Nametags'.add_child(nametag_node);

	if add_to_world:
		add_player_to_world(player_node);

	return player_node;

func add_player_to_world(node):
	$'/root/Root/World/Players'.add_child(node);

# Initialize the game's world and other nodes
remote func init_game(packet):
	players = packet.players;

	var map_node = load("res://Maps/" + packet.map.name + ".tscn").instance();
	map_node.set_name("World");

	var nametags_node = CanvasLayer.new();
	nametags_node.set_name("Nametags");

	map_node.add_child(nametags_node);

	$'/root/Root'.add_child(map_node);

	print("Amount of players: ", players.size());

	# Spawn all players (including own player)
	for p in players:
		create_player_node(p, players[p].position);

	rpc_id(1, "done_loading_game", packet.player.client_id);

# A certain player is done loading their game.
remote func done_loading_game(client_id):
	players[client_id].done_loading = true;
	print(client_id, " done loading the game, finna notify everybody else.");

	# Because we already spawned our player before
	# We check if this new player is us so we dont spawn again
	if(client_id != get_tree().get_network_unique_id()):
		create_player_node(client_id, players[client_id].position);

# Successfully joined the server
remote func _joined_server(r_packet):
	players = r_packet.players;

	var map_node = load("res://Maps/" + r_packet.map.name + ".tscn").instance();
	map_node.set_name("World");

	var nametags_node = CanvasLayer.new();
	nametags_node.set_name("Nametags");

	map_node.add_child(nametags_node);

	$'/root/Root'.add_child(map_node);

	# Spawn all players (including own player)
	for p in players:
		create_player_node(p, players[p].position);

	rpc_id(1, "_done_loading_game", r_packet.player.client_id);

# A new player just joined
remote func register_player(player):
	players[player.client_id] = player;

	print("Player with id ", player.client_id, " and named ", player.display_name, " added to list of players: ", players);

remote func player_left(client_id):
	print("Player ", players[client_id].display_name, " left the game.");
	players.erase(client_id);

	# Delete player node
	get_tree().get_root().get_node('/root/Root/World/Players/' + str(client_id)).queue_free();
