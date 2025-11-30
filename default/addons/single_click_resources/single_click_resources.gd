@tool
extends EditorPlugin

const IGNORED_EXTENSIONS = [
	"gd",
	"cs",
	"tscn",
	"gltf",
	"glb",
	"fbx",
	"blend",
	"gdshader",
	"gdshaderinc"
]

var _tree: Tree

func _enter_tree() -> void:
	var filesystem_dock = EditorInterface.get_file_system_dock()
	_tree = filesystem_dock.find_children("", "Tree", true, false)[0]
	_tree.cell_selected.connect(_on_cell_selected)

func _exit_tree() -> void:
	_tree.cell_selected.disconnect(_on_cell_selected)

func _on_cell_selected() -> void:
	# Early exit if trying to select multiple files
	if Input.is_key_pressed(KEY_CTRL)\
		or Input.is_key_pressed(KEY_META)\
		or Input.is_key_pressed(KEY_SHIFT):
		return

	var selected_item = _tree.get_selected()

	# Wait for left mouse button to be released
	while Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		await get_tree().process_frame

	# Check if mouse is still over the same item to prevent activation
	# when dragging files inside or outside the tree
	var mouse_local_pos = _tree.get_local_mouse_position()
	var item_at_mouse_pos = _tree.get_item_at_position(mouse_local_pos)
	if item_at_mouse_pos != selected_item:
		return

	var file_extension = _tree.get_selected().get_text(0).get_extension()

	# Ignore folders or extensions that might trigger other apps or
	# changes in godot UI (i.e import popups, opening bottom panel, etc)
	if file_extension == "" or file_extension in IGNORED_EXTENSIONS:
		return

	_tree.item_activated.emit()
