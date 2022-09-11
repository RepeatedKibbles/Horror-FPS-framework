extends Control

func _ready():
	$Panel/Playername.text = $'/root/PlayerInfo'.player.display_name;
	pass

func _on_ResumeGame_pressed():
	hide();

func _on_BackToMainMenu_pressed():
	get_tree().set_network_peer(null);
	get_tree().change_scene("res://Scenes/GUI/MainMenu.tscn");

func _on_QuitButton_pressed():
	# TODO: Send network message
	get_tree().set_network_peer(null);
	get_tree().quit();

func _input(event):
	if event is InputEventKey:
		if(event.is_action_pressed("ui_cancel")):
			toggle();

func toggle():
	if is_visible():
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);
		hide();
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);
		show();
