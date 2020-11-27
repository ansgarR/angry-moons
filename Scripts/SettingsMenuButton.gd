extends MenuButton

var popup : PopupMenu
signal setting_change(id, value)

func _ready():
	popup = get_popup()
	popup.connect("id_pressed", self, "_on_item_pressed")

func _on_item_pressed(ID):
	var item_checked = popup.is_item_checked(ID)
	popup.set_item_checked(ID, !item_checked)
	emit_signal("setting_change", ID, !item_checked)
