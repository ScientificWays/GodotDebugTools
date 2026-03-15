extends Control
class_name GameplayDebuggerUI

@onready var tab: TabContainer = $Panel/TabContainer
@onready var close_btn = $Panel/CloseButton

func _ready():
	visible = false
	# Зарегистрировать себя в DebugManager
	GameplayDebugger.categories_changed.connect(_on_categories_changed)

func _on_categories_changed() -> void:
	# Удаляем старые вкладки
	for i in range(tab.get_tab_count() - 1, -1, -1):
		tab.remove_tab(i)
	# Построить вкладки заново
	for id in GameplayDebugger.categories:
		var meta = GameplayDebugger.categories[id]
		var title = meta.title
		var instance = meta.instance
		var cont = VBoxContainer.new()
		cont.name = id
		# Вызвать рендер категории — она должна самостоятельно заполнить cont
		if instance and instance.has_method("render"):
			instance.render(cont)
		else:
			var category_label = Label.new()
			category_label.set_text("No render() implemented")
			cont.add_child(category_label)
		tab.add_child(cont)
		tab.set_tab_title(tab.get_tab_count()-1, title)

func _on_CloseButton_pressed():
	visible = false
