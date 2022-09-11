extends Control

const ServerItem = preload("ServerItem.tscn");

var listIndex = 0;

var client = null;
var wrapped_client = null;

var count = 0;

func _ready():
	client = StreamPeerTCP.new();
	connect_to_server("127.0.0.1", 1337);

func addServer(name, ping):
	var server = ServerItem.instance();
	listIndex += 1;
	server.get_node("ID").text = str(listIndex);
	server.get_node("Name").text = name;
	server.get_node("Ping").text = str(ping) + 'ms';
	server.rect_min_size = Vector2(900, 30);

	$Panel/ScrollContainer/Servers.add_child(server);

func _process(delta):

	#debug = self.get_child(0).get_child(0) # keep updating reference to debug

	# Check if client is connected and has data before attempting to read data
	if client.is_connected_to_host() && wrapped_client.get_available_packet_count() > 0:
		print("Received: ", str(wrapped_client.get_var()))
	if client.get_status() == 1: # if client is connecting
		count = count + delta
	if count > 1: # if it took more than 1s to connect, error
		print("Stuck connecting, please press disconnect")
		client.disconnect_from_host() #interrupts connection to nothing
		set_process(false) # stop listening for packets

func connect_to_server(host, port):
	if !client.is_connected_to_host():
		# Connect to server
		client.connect_to_host(host, port);

		# Wrap the StreamPeerTCP in a PacketPeerStream
		wrapped_client = PacketPeerStream.new()
		wrapped_client.set_stream_peer(client)
		wrapped_client.put_var("get_servers");
		set_process(true) # start listening for packets
	else:
		print("Already connected...");

func send_to_server(data):
	# Check if client is connected before attempting to send data

	if client.is_connected_to_host():
		print("Sending: "+ str(data))
		# Send data
		wrapped_client.put_var(data)