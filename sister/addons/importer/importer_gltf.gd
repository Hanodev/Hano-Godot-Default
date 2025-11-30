@tool
extends EditorScenePostImport

# Configuration - you can modify these values
const MATERIALS_PATH = "assets/materials/"
const SEARCH_SUBDIRECTORIES = true
const CASE_SENSITIVE = false

func _post_import(scene):
	#print("Starting material replacement for: ", get_source_file())

	# Find and cache all available materials
	var available_materials = find_materials(MATERIALS_PATH, SEARCH_SUBDIRECTORIES, CASE_SENSITIVE)

	if available_materials.is_empty():
		#print("No materials found in directory: ", MATERIALS_PATH)
		return scene

	# Replace materials in the scene
	replace_materials_recursive(scene, available_materials, CASE_SENSITIVE)

	#print("Material replacement completed")
	return scene

func find_materials(base_path: String, search_subdirs: bool, case_sensitive: bool) -> Dictionary:
	var materials = {}
	var full_path = "res://" + base_path
	var dir = DirAccess.open(full_path)

	if dir == null:
	#	print("Could not open materials directory: ", full_path)
		return materials

	_scan_directory_for_materials(dir, "", materials, search_subdirs, case_sensitive)

	#print("Found ", materials.size(), " materials in ", base_path)
	#for mat_name in materials.keys():
		#print("  - ", mat_name, " -> ", materials[mat_name])

	return materials

func _scan_directory_for_materials(dir: DirAccess, relative_path: String, materials: Dictionary, search_subdirs: bool, case_sensitive: bool):
	dir.list_dir_begin()
	var file_name = dir.get_next()

	while file_name != "":
		if file_name == "." or file_name == "..":
			file_name = dir.get_next()
			continue

		var current_path = dir.get_current_dir() + "/" + file_name

		if dir.current_is_dir() and search_subdirs:
			var sub_dir = DirAccess.open(current_path)
			if sub_dir:
				var new_relative = relative_path + "/" + file_name if relative_path != "" else file_name
				_scan_directory_for_materials(sub_dir, new_relative, materials, search_subdirs, case_sensitive)
		elif file_name.ends_with(".tres") or file_name.ends_with(".res"):
			# Try to load the resource to check if it's a material
			var resource = load(current_path)

			if resource is Material:
				var material_name = file_name.get_basename()
				var key = material_name.to_lower() if not case_sensitive else material_name
				materials[key] = current_path

		file_name = dir.get_next()

func replace_materials_recursive(node: Node, available_materials: Dictionary, case_sensitive: bool):
	# Check if this is a MeshInstance3D with materials to replace
	if node is MeshInstance3D:
		replace_mesh_materials(node, available_materials, case_sensitive)

	# Check for other node types with materials
	if node.has_method("get_material_override") and node.get("material_override") != null:
		replace_node_material(node, available_materials, case_sensitive)

	# Recursively process children
	for child in node.get_children():
		replace_materials_recursive(child, available_materials, case_sensitive)

func replace_mesh_materials(mesh_instance: MeshInstance3D, available_materials: Dictionary, case_sensitive: bool):
	if mesh_instance.mesh == null:
		return

	var mesh = mesh_instance.mesh
	var surface_count = mesh.get_surface_count()

	for surface_idx in range(surface_count):
		var current_material = mesh_instance.get_surface_override_material(surface_idx)
		if current_material == null:
			current_material = mesh.surface_get_material(surface_idx)

		if current_material:
			var material_name = extract_material_name(current_material)
			var replacement_path = find_matching_material(material_name, available_materials, case_sensitive)

			if replacement_path != "":
			#	print("Replacing material '", material_name, "' with '", replacement_path, "' on surface ", surface_idx)
				var loaded_material = load(replacement_path)
				if loaded_material:
					mesh_instance.set_surface_override_material(surface_idx, loaded_material)
			#	else:
				#	print("Failed to load replacement material: ", replacement_path)
		#	else:
			#	print("No replacement found for material: ", material_name)

func replace_node_material(node: Node, available_materials: Dictionary, case_sensitive: bool):
	var current_material = node.get("material_override")
	if current_material and current_material is Material:
		var material_name = extract_material_name(current_material)
		var replacement_path = find_matching_material(material_name, available_materials, case_sensitive)

		if replacement_path != "":
			print("Replacing node material '", material_name, "' with '", replacement_path)
			var loaded_material = load(replacement_path)
			if loaded_material:
				node.set("material_override", loaded_material)
			else:
				print("Failed to load replacement material: ", replacement_path)

func extract_material_name(material: Material) -> String:
	# Try to get a meaningful name from the material
	if material.resource_name != "":
		return material.resource_name
	elif material.resource_path != "":
		return material.resource_path.get_file().get_basename()
	else:
		# Fallback to a generic name based on the material type
		return material.get_class()

func find_matching_material(material_name: String, available_materials: Dictionary, case_sensitive: bool) -> String:
	var search_key = material_name.to_lower() if not case_sensitive else material_name

	# Direct match
	if available_materials.has(search_key):
		return available_materials[search_key]

	# Fuzzy matching - look for partial matches
	for available_key in available_materials.keys():
		var available_name = available_key if case_sensitive else available_key.to_lower()
		var search_name = material_name if case_sensitive else material_name.to_lower()

		# Check if either name contains the other
		if available_name.contains(search_name) or search_name.contains(available_name):
			return available_materials[available_key]

	return ""
