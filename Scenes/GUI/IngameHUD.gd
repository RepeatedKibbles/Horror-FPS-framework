extends Control

func _process(delta):
	$DisplayName.text = $'/root/PlayerInfo'.player.display_name;
	$FPSCounter.text = "FPS: " + str(Engine.get_frames_per_second());
