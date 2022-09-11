extends AnimationTree

var state_machine = null;

func _ready():
	state_machine = get('parameters/playback');
	state_machine.start('default');
	active = true;
