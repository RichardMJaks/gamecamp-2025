extends CanvasLayer

@onready var temporary_message_container: VBoxContainer = %TemporaryMessageContainer
@onready var permanent_message_container: VBoxContainer = %PermanentMessageContainer
@export var font: Font

func send_temp_message(text: String, duration: float) -> void:
	var temp_message_label: Label = Label.new()
	temp_message_label.text = text
	temp_message_label.add_theme_font_override("", font)
	
	temporary_message_container.add_child(temp_message_label)

	var message_tweener = temp_message_label.create_tween()
	message_tweener.tween_property(temp_message_label, ^"self_modulate:a", 0, duration)
	message_tweener.tween_callback(temp_message_label.queue_free)



func send_perm_message(text: String, msg_name: String) -> void:
	var perm_message_label: Label = Label.new()
	perm_message_label.text = text
	perm_message_label.name = msg_name
	perm_message_label.add_theme_font_override("", font)

	permanent_message_container.add_child(perm_message_label)

func remove_perm_message(msg_name: String) -> void:
	var label = permanent_message_container.get_node_or_null(msg_name)
	if not label:
		return

	label.queue_free()
