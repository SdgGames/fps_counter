extends ColorRect

export var enabled: bool setget set_enabled, get_enabled
export var frame_range = 120
export var average = 0
export var highest = 0
export var lowest = 0

var fps_buffer: Array
var fps_buffer_idx: int


# Register the FPS counter with a console if the console exists.
func _ready():
	if $"/root".has_node("Console"):
		Console.add_command("fps", self, 'toggle_enabled')\
				.set_description("Enables or disables the FPS counter.")\
				.register()


func toggle_enabled():
	set_enabled(!enabled)

func set_enabled(value: bool):
	visible = value
	enabled = value

func get_enabled():
	return visible


func initialize_buffer():
	fps_buffer.resize(frame_range)
	fps_buffer_idx = 0
	for frame in frame_range:
		fps_buffer[frame] = 60


func _process(delta):
	if enabled:
		if fps_buffer.size() != frame_range:
			initialize_buffer()
		
		# Update the buffer.
		var fps = 1 / delta
		if fps > 0 and fps < 2000: # Sanity check, things get weird when a window resizes
			fps_buffer[fps_buffer_idx] = fps
		
		fps_buffer_idx += 1
		if fps_buffer_idx >= frame_range:
			fps_buffer_idx = 0
		
		# Calcuate the frame rate from the buffer.
		var sum: int = 0
		highest = 0
		lowest = INF
		
		for frame in frame_range:
			fps = fps_buffer[frame]
			sum += fps
			if fps > highest:
				highest = fps
			if fps < lowest:
				lowest = fps
			
		#warning-ignore:integer_division
		average = sum / frame_range
		
		$Label.text = "Minimum: %s\nMaximum: %s\nAverage: %s" % [str(lowest), str(highest), str(average)]
