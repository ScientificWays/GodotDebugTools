@tool
extends EditorPlugin

const _GDCONSOLE_SETTINGS: Dictionary = {
	"general": {
		"max_history_size": {
			"type": TYPE_INT,
			"default_value": 100,
			"hint": PROPERTY_HINT_NONE,
			"hint_string": "test",
		},
	},
	"colors": {
		"output_background_color": {
			"type": TYPE_COLOR,
			"default_value": Color(0, 0, 0, 0.784),
			"hint": PROPERTY_HINT_NONE,
			"hint_string": "test",
		},
		"input_background_color": {
			"type": TYPE_COLOR,
			"default_value": Color(0.098, 0.098, 0.098, 0.784),
			"hint": PROPERTY_HINT_NONE,
			"hint_string": "test",
		},
		"font_color": {
			"type": TYPE_COLOR,
			"default_value": Color(1, 1, 1, 1),
			"hint": PROPERTY_HINT_NONE,
			"hint_string": "test",
		},
	},
}

func _enable_plugin() -> void:
	
	add_autoload_singleton("GameplayDebugger", "GameplayDebugger/GameplayDebugger.gd")
	add_autoload_singleton("DebugMenu", "DebugMenu/DebugMenu.tscn")
	add_autoload_singleton("GDConsole", "GDConsole/GDConsole.gd")
	
	_add_project_settings()

func _disable_plugin() -> void:
	
	remove_autoload_singleton("GameplayDebugger")
	remove_autoload_singleton("DebugMenu")
	remove_autoload_singleton("GDConsole")
	
	_remove_project_settings()

# Initialization of the plugin goes here.
func _enter_tree() -> void:
	pass

# Clean-up of the plugin goes here.
func _exit_tree() -> void:
	pass

func _add_project_settings() -> void:
	
	##
	## GDConsole
	##
	for section: String in _GDCONSOLE_SETTINGS:
		
		for setting: String in _GDCONSOLE_SETTINGS[section]:
			
			var setting_name: String = "gdconsole/%s/%s" % [section, setting]
			if not ProjectSettings.has_setting(setting_name):
				ProjectSettings.set_setting(setting_name, \
				_GDCONSOLE_SETTINGS[section][setting]["default_value"])
			
			ProjectSettings.set_initial_value(setting_name, _GDCONSOLE_SETTINGS[section][setting]["default_value"])
			ProjectSettings.set_as_basic(setting_name, true)
	
	##
	## DebugMenu
	##
	if not ProjectSettings.has_setting("application/config/version") or ProjectSettings.get_setting("application/config/version") == "":
		ProjectSettings.set_setting("application/config/version", "1.0.0")
		print('Debug Menu: Setting "application/config/version" was missing or empty and has been set to "1.0.0".')
	
	ProjectSettings.add_property_info({
		name = "application/config/version",
		type = TYPE_STRING,
	})
	
	var error: int = ProjectSettings.save()
	
	if not error == OK:
		push_error("GDConsole - error %s while saving project settings." % error_string(error))

func _remove_project_settings() -> void:
	
	##
	## GDConsole
	##
	for section: String in _GDCONSOLE_SETTINGS:
		
		for setting: String in _GDCONSOLE_SETTINGS[section]:
			
			var setting_name: String = "gdconsole/%s/%s" % [section, setting]
			if ProjectSettings.has_setting(setting_name):
				ProjectSettings.set_setting(setting_name, null)
			
			var error: int = ProjectSettings.save()
			
			if not error == OK:
				push_error("GDConsole - error %s while saving project settings." % error_string(error))
