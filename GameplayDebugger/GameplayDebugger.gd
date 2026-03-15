extends Node

# Хранилище категорий: {id: {title: String, instance: Object}}
var categories: Dictionary = {}

# Ссылка на UI overlay (Control). Устанавливается при загрузке сцены оверлея.
@export var overlay_node_path: NodePath
var overlay: GameplayDebuggerUI = null

signal categories_changed()

func _ready() -> void:
	if overlay_node_path != NodePath():
		overlay = get_node_or_null(overlay_node_path)
	categories_changed.emit()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"debug_gameplay_debugger") and not event.echo:
		toggle_overlay()

func register_category(category: String, title: String, instance: Object) -> void:
	# instance должен реализовывать метод `render(parent: Control)` и опционально `on_activate()`
	categories[category] = {"title": title, "instance": instance}
	categories_changed.emit()

func unregister_category(category: String) -> void:
	if categories.has(category):
		categories.erase(category)
	categories_changed.emit()

func toggle_overlay() -> void:
	if overlay:
		overlay.visible = not overlay.visible

func is_registered(category: String) -> bool:
	return categories.has(category)
