extends Node

const ARCHIVE := "res://addons.zip"
const TARGET := "user://addons"

func _ready() -> void:
	var err := extract_addons()
	if err != OK:
		push_error("Runtime addon extraction failed: %s" % err)
	else:
		print("Runtime addon extraction completed: ", ProjectSettings.globalize_path(TARGET))

func extract_addons() -> Error:
	if not FileAccess.file_exists(ARCHIVE):
		return ERR_FILE_NOT_FOUND
	var reader := ZIPReader.new()
	var err := reader.open(ARCHIVE)
	if err != OK:
		return err
	for entry in reader.get_files():
		var clean := entry.replace("\\", "/")
		if clean.begins_with("/") or clean.contains("../"):
			continue
		var output := TARGET + "/" + clean
		if entry.ends_with("/"):
			DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(output))
			continue
		DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(output.get_base_dir()))
		var f := FileAccess.open(output, FileAccess.WRITE)
		if f == null:
			reader.close()
			return ERR_CANT_OPEN
		f.store_buffer(reader.read_file(entry))
		f.close()
	reader.close()
	return OK
