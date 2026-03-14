extends Node

# Хранилище категорий: {id: {title: String, instance: Object}}
var categories: Dictionary = {}

# Ссылка на UI overlay (Control). Устанавливается при загрузке сцены оверлея.
@export var overlay_node_path: NodePath
var overlay: Control = null

func _ready():
	if overlay_node_path != NodePath():
		overlay = get_node_or_null(overlay_node_path)
	_update_overlay()

func register_category(id: String, title: String, instance: Object) -> void:
	# instance должен реализовывать метод `render(parent: Control)` и опционально `on_activate()`
	categories[id] = {"title": title, "instance": instance}
	_update_overlay()

func unregister_category(id: String) -> void:
	if categories.has(id):
		categories.erase(id)
	_update_overlay()

func _update_overlay() -> void:
	if overlay:
		overlay.call_deferred("rebuild_categories", categories)

func toggle_overlay() -> void:
	if overlay:
		overlay.visible = not overlay.visible

# Удобный метод для скриптов:
func is_registered(id: String) -> bool:
	return categories.has(id)
