tool
extends 'BaseNode.gd'

# ******************************************************************************

onready var TextEdit = find_node('TextEdit')
var scrollbar = null

onready var choices = [
	$Choice1,
	$Choice2,
	$Choice3,
	$Choice4,
]

# ******************************************************************************

func _ready():
	Edit.get_popup().connect('index_pressed', self, 'index_pressed')

	data['show_choices'] = false
	set_choices_enabled(false)
	Edit.get_popup().set_item_checked(0, false)

	data['choices'] = {}
	for c in choices:
		data['choices'][c.name[6]] = {}

	TextEdit.refresh_colors()
	Skein.connect('refreshed', TextEdit, 'refresh_colors')
	TextEdit.connect('text_changed', self, 'on_change')
	for c in choices:
		c.Choice.connect('text_changed', self, 'on_change')
		c.Condition.connect('text_changed', self, 'on_change')

	for child in TextEdit.get_children():
		if child is VScrollBar:
			scrollbar = child

	set_slot_color_right(1, slot_colors[0])
	set_slot_color_right(2, slot_colors[1])
	set_slot_color_right(3, slot_colors[2])
	set_slot_color_right(4, slot_colors[3])

var has_mouse := false

func _input(event: InputEvent) -> void:
	if !(event is InputEventMouseMotion):
		return

	if !scrollbar.visible:
		return

	var local_event = make_input_local(event)

	if Rect2(Vector2(), rect_size).has_point(local_event.position):
		if !has_mouse:
			has_mouse = true
			get_parent().zoom_step = 1.0
	else:
		if has_mouse:
			has_mouse = false
			get_parent().zoom_step = 1.1

func on_change(arg=null):
	emit_signal('changed')

func index_pressed(index):
	match Edit.get_popup().get_item_text(index):
		'Choices':
			Edit.get_popup().toggle_item_checked(0)
			var state = Edit.get_popup().is_item_checked(0)
			data['show_choices'] = state
			set_choices_enabled(state)
			emit_signal('changed')

func highlight_line(line_number):
	TextEdit.highlight_current_line = true
	TextEdit.cursor_set_line(line_number)

func unhighlight_lines():
	TextEdit.highlight_current_line = false
	TextEdit.deselect()


# ******************************************************************************

func get_data():
	var data = .get_data()
	data['text'] = TextEdit.text
	if data['show_choices']:
		data['next'] = 'choice'
	else:
		data.erase('show_choices')

	var connections = {}
	for to in data.connections:
		var num = str(data.connections[to][0] + 1)
		connections[num] = to
	
	if !data.connections:
		data.erase('connections')

	data['choices'] = {}
	for c in choices:
		var c_data = c.get_data()
		if c_data:
			data['choices'][c.name[6]] = c_data
			data['choices'][c.name[6]]['next'] = ''
			if c.name[6] in connections:
				data['choices'][c.name[6]]['next'] = connections[c.name[6]]
	if !data['choices']:
		data.erase('choices')

	return data

func set_data(new_data):
	if 'text' in new_data:
		TextEdit.text = new_data.text
	if 'show_choices' in new_data:
		var state = new_data['show_choices']
		if state is String:
			state = {'True': true, 'False': false}[state]
		data['show_choices'] = state
		set_choices_enabled(state)
		Edit.get_popup().set_item_checked(0, state)
	if 'choices' in new_data:
		for c in choices:
			if c.name[6] in new_data['choices']:
				c.set_data(new_data['choices'][c.name[6]])

	.set_data(new_data)

# ******************************************************************************

func set_choices_enabled(state):
	$Choice1.visible = state
	$Choice2.visible = state
	$Choice3.visible = state
	$Choice4.visible = state

	set_slot_enabled_right(0, !state)
	set_slot_enabled_right(1, state)
	set_slot_enabled_right(2, state)
	set_slot_enabled_right(3, state)
	set_slot_enabled_right(4, state)
