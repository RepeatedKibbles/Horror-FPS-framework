extends Node

func _on_Button_pressed():
	$UISound.play()
	$FadeIn.show()
	$FadeIn.fade_in()

func _on_FadeIn_fade_finished():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Menu/Main Menu.tscn")

func _on_1_pressed():
	get_tree().change_scene("res://maps/World/World.tscn");

func _on_2_pressed():
	get_tree().change_scene("res://maps/Proto/Prototype.tscn");
