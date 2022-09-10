extends CanvasLayer

export var enabled: bool setget set_enabled, get_enabled
onready var counter = $Counter


# Register the FPS counter with a console if the console exists.
func _ready():
	if $"/root".has_node("Console"):
		Console.add_command("fps", self, 'toggle_enabled')\
				.set_description("Enables or disables the FPS counter.")\
				.register()
	
	set_enabled(enabled)


func toggle_enabled():
	set_enabled(!enabled)


func set_enabled(value: bool):
	visible = value
	enabled = value
	counter.enabled = enabled


func get_enabled():
	return visible
