extends Control

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS

func _on_ResumeGame_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);
	get_tree().paused = false
	hide();

func _on_BackToMainMenu_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://Menu/Main Menu.tscn");

func _on_QuitButton_pressed():
	get_tree().quit();

func _input(event):
	if event is InputEventKey:
		if(event.is_action_pressed("ui_cancel")):
			get_tree().paused = true
			toggle();

func toggle():
	if is_visible():
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);
		get_tree().paused = false
		hide();
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);
		get_tree().paused = true
		show();
