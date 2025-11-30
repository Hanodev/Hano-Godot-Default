@tool
extends Resource
class_name SceneBuilderItem

@export var collection_name: String = "Temporary"
@export var item_name: String = "TempItemName"

@export var texture: Texture
@export var uid: String

@export_tool_button("Delete resource") var delete = delete_res

func delete_res():
	print("Deleting ", resource_path)
	if len(resource_path) != 0:
		DirAccess.remove_absolute(resource_path)
