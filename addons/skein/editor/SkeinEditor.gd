tool
extends Control

# ******************************************************************************

onready var GraphEdit: GraphEdit = find_node('GraphEdit')
onready var Tree: Tree = find_node('Tree')
onready var ConfirmClear: ConfirmationDialog = find_node('ConfirmClear')
onready var ConfirmDelete: ConfirmationDialog = find_node('ConfirmDelete')
onready var Run = find_node('Run')
# onready var Play = find_node('Play')
onready var ConfirmationDimmer = find_node('ConfirmationDimmer')
onready var Refresh = find_node('Refresh')
onready var Stop = find_node('Stop')
onready var Next = find_node('Next')
onready var Debug = find_node('Debug')
onready var Preview = find_node('Preview')
onready var GraphToolbar = find_node('GraphToolbar')
onready var DialogBox = find_node('DialogBox')
onready var ToggleRightPanel = find_node('ToggleRightPanel')
onready var ToggleLeftPanel = find_node('ToggleLeftPanel')
onready var LeftPanelSplit: HSplitContainer = find_node('LeftPanelSplit')
onready var RightPanelSplit: HSplitContainer = find_node('RightPanelSplit')
onready var LeftSidebar: Control = find_node('LeftSidebar')
onready var RightSidebar: Control = find_node('RightSidebar')
onready var SettingsMenu: MenuButton = find_node('SettingsMenu')

export var position := 'default'

var plugin = null
var current_conversation := ''
var editor_data := {}
var ignore_next_refresh := false

# ******************************************************************************

func _ready():
	if Engine.editor_hint and !plugin:
		return

	Run.connect('pressed', self, 'run')
	# Play.connect('pressed', self, 'run')
	Stop.connect('pressed', self, 'stop')
	Next.connect('pressed', self, 'next')
	Debug.connect('toggled', $Preview/DialogBox/DebugLog, 'set_visible')

	Preview.hide()
	ConfirmDelete.connect('popup_hide', Skein, 'refresh')
	ConfirmDelete.connect('popup_hide', ConfirmationDimmer, 'hide')
	ConfirmDelete.connect('confirmed', self, 'really_delete_conversation')

	Refresh.connect('pressed', Skein, 'refresh')

	Skein.connect('refreshed', Tree, 'refresh')
	Tree.connect('folder_collapsed', self, 'save_editor_data')
	Tree.connect('create_folder', self, 'create_folder')
	Tree.connect('delete_folder', self, 'delete_folder')
	Tree.connect('rename_folder', self, 'rename_folder')
	Tree.connect('change_conversation', self, 'change_conversation')
	Tree.connect('create_conversation', self, 'create_conversation')
	Tree.connect('delete_conversation', self, 'delete_conversation')
	Tree.connect('rename_conversation', self, 'rename_conversation')
	Tree.connect('select_node', GraphEdit, 'select_node')
	Tree.connect('focus_node', self, 'focus_card')
	Tree.connect('rename_node', GraphEdit, 'rename_node')
	Tree.connect('delete_node', GraphEdit, 'delete_node')
	Tree.connect('run_node', self, 'run')

	ToggleLeftPanel.connect('pressed', self, 'toggle_left_panel')
	ToggleRightPanel.connect('pressed', self, 'toggle_right_panel')

	# right sidebar should be closed by default
	RightSidebar.hide()

	GraphEdit.connect('node_renamed', self, 'node_renamed')
	GraphEdit.connect('node_created', self, 'node_created')
	GraphEdit.connect('node_deleted', self, 'node_deleted')
	GraphEdit.connect('node_selected', self, 'node_selected')

	GraphEdit.connect('node_changed', self, 'node_changed')

	if plugin:
		SettingsMenu.add_item('Set as Preferred Editor', [plugin, 'set_preferred_editor', position])
	var sub = SettingsMenu.create_submenu('Set Font Size', 'FontSize')
	sub.hide_on_item_selection = false
	SettingsMenu.add_submenu_item('Font Size Reset', 'FontSize', [self, 'reset_font_size'])
	SettingsMenu.add_submenu_item('Font Size +', 'FontSize', [self, 'set_font_size', 1])
	SettingsMenu.add_submenu_item('Font Size -', 'FontSize', [self, 'set_font_size', -1])

	Skein.connect('refreshed', self, 'refresh')
	
	DialogBox.connect('done', self, 'dismiss_preview')
	DialogBox.connect('line_started', self, 'line_started')
	DialogBox.connect('node_started', self, 'node_started')

	$AutoSave.connect('timeout', self, 'autosave')

func refresh():
	if ignore_next_refresh:
		ignore_next_refresh = false
		return

	load_editor_data()
	var zoom_hbox = GraphEdit.get_zoom_hbox()
	var zoom_container = GraphToolbar.find_node('ZoomContainer')
	zoom_hbox.get_parent().remove_child(zoom_hbox)
	zoom_container.add_child(zoom_hbox)

	if current_conversation:
		load_conversation(current_conversation, true)

func save():
	ignore_next_refresh = true
	save_conversation()
	save_editor_data()

func autosave():
	# save_conversation()
	save_editor_data()

func node_changed():
	save()

func toggle_left_panel():
	LeftSidebar.visible = !LeftSidebar.visible

func toggle_right_panel():
	RightSidebar.visible = !RightSidebar.visible

func reset_font_size():
	theme.default_font.size = 12

func set_font_size(amount):
	theme.default_font.size += amount

func dialog_font_minus():
	DialogBox.theme.default_font.size -= 1

func dialog_font_plus():
	DialogBox.theme.default_font.size += 1

# ******************************************************************************

func save_conversation():
	if !current_conversation:
		return
	var nodes = GraphEdit.get_nodes()
	if nodes:
		Skein.save_conversation(current_conversation, nodes)

func change_conversation(path):
	save_conversation()
	save_editor_data()
	load_conversation(path)

	var _path = path.trim_prefix(Skein.conversation_prefix)
	var parts = _path.split(':')
	if len(parts) > 1:
		GraphEdit.focus_node(parts[1])

func load_conversation(path, force:=false):
	var _path = path.trim_prefix(Skein.conversation_prefix)
	var parts = _path.split(':')
	var name = parts[0]

	if !force and current_conversation == name:
		return
	GraphEdit.clear()
	current_conversation = name

	var nodes = Skein.load_conversation(name, {})
	if nodes:
		GraphEdit.set_nodes(nodes)
	if name in editor_data:
		GraphEdit.call_deferred('set_data', editor_data[name])
	else:
		editor_data[name] = {}

# ******************************************************************************

func create_folder(path):
	var dir := Directory.new()
	dir.make_dir_recursive(path)

func delete_folder(path):
	var dir := Directory.new()
	dir.remove(Skein.ensure_prefix(path))
	Skein.refresh()

func rename_folder(old, new):
	var dir := Directory.new()
	dir.rename(Skein.ensure_prefix(old), Skein.ensure_prefix(new))
	Skein.refresh()

# ------------------------------------------------------------------------------

func create_conversation(path):
	GraphEdit.clear()
	current_conversation = path

	var dir = Directory.new()
	dir.make_dir_recursive(path.get_base_dir())

	var file = File.new()
	file.open(path, File.WRITE)
	file.store_string('')
	file.close()
	Skein.refresh()

var delete_path = null
onready var original_size = ConfirmDelete.rect_size

func sort(a, b):
	return a.text.count('\n') > b.text.count('\n')

func delete_conversation(path):
	delete_path = path
	ConfirmDelete.dialog_text = 'Really delete conversation "' + path.get_file() + '" ?\n'
	var nodes = Skein.load_conversation(path, {}).values()
	nodes.sort_custom(self, 'sort')
	var line_count = 0
	for i in range(nodes.size()):
		var count = nodes[i].text.split('\n').size()
		line_count += count
		if i < 5:
			ConfirmDelete.dialog_text += ' - %s [%s lines]\n' % [nodes[i].name, count]
		if i == 5:
			ConfirmDelete.dialog_text += 'plus ' + str(nodes.size() - i) + ' more..'
	if nodes.size() > 10 or line_count > 25:
		ConfirmDelete.get_ok().disabled = true
		ConfirmDelete.get_ok().text = '3..'
		get_tree().create_timer(1.0).connect('timeout', ConfirmDelete.get_ok(), 'set_text', ['2..'])
		get_tree().create_timer(2.0).connect('timeout', ConfirmDelete.get_ok(), 'set_text', ['1..'])
		get_tree().create_timer(3.0).connect('timeout', ConfirmDelete.get_ok(), 'set_text', ['Ok'])
		get_tree().create_timer(3.0).connect(
			'timeout', ConfirmDelete.get_ok(), 'set_disabled', [false]
		)
	ConfirmDelete.popup_centered()
	ConfirmDelete.rect_size.y = 0
	ConfirmationDimmer.show()

func really_delete_conversation():
	if current_conversation == delete_path:
		GraphEdit.clear()
		current_conversation = ''
	editor_data.erase(delete_path)
	save_editor_data()
	var dir = Directory.new()
	if delete_path.begins_with(Skein.prefix):
		dir.remove(delete_path)
	if delete_path in Skein.conversations:
		dir.remove(Skein.conversations[delete_path])
	Skein.refresh()

func rename_conversation(old, new):
	old = Skein.ensure_prefix(old)
	new = Skein.ensure_prefix(new)

	if current_conversation == old:
		GraphEdit.clear()
		current_conversation = ''
	if old in editor_data:
		editor_data[new] = editor_data[old]
		editor_data.erase(old)
	save_editor_data()
	var dir := Directory.new()
	dir.rename(old, new)
	load_conversation(new)
	Skein.refresh()

func focus_card(path):
	var _path = path.trim_prefix(Skein.conversation_prefix)
	var parts = _path.split(':')
	if parts[0] != current_conversation:
		save_conversation()
		save_editor_data()
		load_conversation(parts[0])
	if len(parts) > 1:
		GraphEdit.focus_node(parts[1])

func node_selected(node):
	var path = current_conversation + '/' + node.data.name
	Tree.select_item(path)

func node_deleted(id):
	Tree.delete_item(id)
	save()

func node_renamed(old, new):
	Tree.refresh()

func node_created(path):
	Tree.refresh()

func select_card(path):
	prints('select_card', path)
	# GraphEdit

# ******************************************************************************

func character_added(path):
	var char_map = Skein.load_json(Skein.character_map_path, {})
	var c = load(path).instance()
	char_map[c.name] = path
	Skein.save_json(Skein.character_map_path, char_map)
	Skein.refresh()

# ******************************************************************************

func run():
	Skein.load_characters()
	var selection = GraphEdit.get_selected_nodes()

	var conversation = current_conversation
	var entry = ''
	if selection.size() == 1:
		var node = selection[0]
		entry = node.name
	else:
		for node in GraphEdit.nodes.values():
			if node.data.default:
				entry = node.name

	if entry:
		conversation += ':' + entry
	save_conversation()
	save_editor_data()
	$Preview.show()

	DialogBox.start(conversation, {exec = false})

func stop():
	DialogBox.stop()
	dismiss_preview()

func dismiss_preview():
	$Preview.hide()
	GraphEdit.unhighlight_all_nodes()

func next():
	DialogBox.next_line()

func line_started(id, line_number):
	var node = GraphEdit.get_node(id)
	if node and node.has_method('highlight_line'):
		node.highlight_line(line_number)

func node_started(id):
	GraphEdit.focus_node(id)
	GraphEdit.highlight_node(id)

# ******************************************************************************

var editor_data_file_name = 'user://skein/editor_data.json'

func save_editor_data():
	if !current_conversation:
		return
	var data = Skein.load_json(editor_data_file_name, {})
	if !(position in data):
		data[position] = {
			'conversation_data' : {}
		}
	
	data[position]['folder_state'] = Tree.folder_state
	data[position]['current_conversation'] = current_conversation
	# data[position]['font_size'] = theme.default_font.size
	data[position]['left_panel_size'] = LeftPanelSplit.split_offset
	data[position]['left_panel_collapsed'] = LeftSidebar.visible
	data[position]['right_panel_size'] = RightPanelSplit.split_offset
	data[position]['right_panel_collapsed'] = RightSidebar.visible
	data[position]['conversation_data'][current_conversation] = GraphEdit.get_data()
	Skein.save_json(editor_data_file_name, data)

func load_editor_data():
	var data = Skein.load_json(editor_data_file_name, {})
	if !data or !(position in data):
		editor_data['current_conversation'] = '0 Introduction'
		load_conversation(editor_data['current_conversation'])
		return
	editor_data = data[position]

	if 'folder_state' in editor_data:
		Tree.folder_state = editor_data['folder_state']
	if 'current_conversation' in editor_data:
		load_conversation(editor_data['current_conversation'])

	# if 'font_size' in editor_data:
	# 	theme.default_font.size = editor_data['font_size']

	if 'left_panel_size' in editor_data:
		LeftPanelSplit.split_offset = editor_data['left_panel_size']
	if 'left_panel_collapsed' in editor_data:
		LeftSidebar.visible = editor_data['left_panel_collapsed']

	if 'right_panel_size' in editor_data:
		RightPanelSplit.split_offset = editor_data['right_panel_size']
	if 'right_panel_collapsed' in editor_data:
		RightSidebar.visible = editor_data['right_panel_collapsed']
