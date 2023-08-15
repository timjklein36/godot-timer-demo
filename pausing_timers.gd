extends Control

@onready var INVALID_THEME = preload('res://invalid_theme.tres')

enum TIMERS {
	one,
	two
}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	get_timer_node(TIMERS.one, 'TimeLabel').text = '%.1f' % %Timer1.time_left
	get_timer_node(TIMERS.two, 'TimeLabel').text = '%.1f' % %Timer2.time_left
	
	get_timer_node(TIMERS.one, 'StateLabel').text = (
		'Paused' if %Timer1.is_paused() else ('Stopped' if %Timer1.is_stopped() else 'Running')
	)
	get_timer_node(TIMERS.two, 'StateLabel').text = (
		'Paused' if %Timer2.is_paused() else ('Stopped' if %Timer2.is_stopped() else 'Running')
	)


func get_timer_node(timer: TIMERS, node_name: String):
	var timer_container = get_node(
		'MarginContainer/CenterContainer/HBoxContainer/Timer{0}VBoxContainer'.format(
			[1 if timer == TIMERS.one else 2]
		)
	)
	return timer_container.get_node(node_name)


func _on_line_edit_text_changed(_new_text):
	for timer in [TIMERS.one, TIMERS.two]:
		var timer_node = %Timer1 if timer == TIMERS.one else %Timer2
		
		var line_edit = get_timer_node(timer, 'LineEdit')
		var wait_time = float(get_timer_node(timer, 'LineEdit').text)
		
		# Check value is valid
		if not line_edit.text.is_valid_float():
			line_edit.theme = INVALID_THEME
			line_edit.tooltip_text = 'Invalid floating point number'
		elif wait_time <= 0.0:
			line_edit.theme = INVALID_THEME
			line_edit.tooltip_text = 'Time must be greater than zero'
		else:
			line_edit.theme = null
			line_edit.tooltip_text = 'Time (in seconds)'
			timer_node.wait_time = wait_time


func _on_timer_1_timeout():
	%Timer1.paused = true
	
	%Timer2.paused = false
	
	if %Timer2.is_stopped():
		%Timer2.start()


func _on_timer_2_timeout():
	%Timer2.paused = true
	
	%Timer1.paused = false
