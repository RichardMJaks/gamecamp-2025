extends Control

@export var first_level: PackedScene

var showing_credits: bool = false
var current_focused: Control = null

@onready var btn_play: TextureButton = %PlayButton
@onready var btn_credits: TextureButton = %CreditsButton
@onready var credits: Control = %Credits
@onready var credits_player: AnimationPlayer = %CreditsPlayer
@onready var transition: Fader = %Transition

var mobile_operating_systems = ["iOS", "Android"]

func _ready() -> void:
	BgMusic.play_music(BgMusic.MusicType.MENU)
	transition.fade_out_finished.connect(GameController.goto_level.bind(first_level))

func _input(event: InputEvent) -> void:
	if showing_credits:
		_handle_credits_input(event)
		return
	
	if not current_focused:
		if event.is_action_released(&"ui_accept"):
			_play_pressed()
		if event.is_action(&"ui_up"):
			btn_play.grab_focus()
			current_focused = btn_play
		if event.is_action(&"ui_down"):
			btn_credits.grab_focus()
			current_focused = btn_credits



func _handle_credits_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"ui_cancel"):
		_hide_credits()
	
	if event.is_action_pressed(&"ui_up"):
		credits_player.speed_scale = 0.3
	if event.is_action_pressed(&"ui_down"):
		credits_player.speed_scale = 3
	if event.is_action_released(&"ui_up") or event.is_action_released(&"ui_down"):
		credits_player.speed_scale = 1

func _process(_delta: float) -> void:		
	if showing_credits and not (Input.is_action_pressed(&"ui_up") or Input.is_action_pressed(&"ui_down")):
		credits_player.speed_scale = 1

func _play_pressed() -> void:
	SignalBus.start_fade_out.emit()

func _on_credits_pressed() -> void:
	showing_credits = true
	
	credits_player.stop()
	credits_player.play(&"display_credits")

	btn_play.release_focus()
	btn_credits.release_focus()
	current_focused = null

func _hide_credits() -> void:
	credits_player.play(&"hide_credits")
	showing_credits = false
