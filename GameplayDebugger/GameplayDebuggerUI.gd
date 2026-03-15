extends Control
class_name GameplayDebuggerUI

@onready var tab: TabContainer = $Panel/TabContainer
@onready var close_button: Button = $Panel/CloseButton

func _ready():
	
	visible = false
	
	close_button.pressed.connect(_on_close_button_pressed)
	
	GameplayDebugger.categories_changed.connect(_on_categories_changed)

func _on_categories_changed() -> void:
	
	for i in range(tab.get_tab_count() - 1, -1, -1):
		tab.remove_tab(i)
	
	for id in GameplayDebugger.categories:
		var meta = GameplayDebugger.categories[id]
		var title = meta.title
		var instance = meta.instance
		var content = VBoxContainer.new()
		content.name = id
		
		if instance and instance.has_method("render"):
			instance.render(content)
		else:
			var category_label = Label.new()
			category_label.set_text("No render() implemented")
			content.add_child(category_label)
		tab.add_child(content)
		tab.set_tab_title(tab.get_tab_count() - 1, title)

func _on_close_button_pressed():
	visible = false
