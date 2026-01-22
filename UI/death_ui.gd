extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Panel/Panel/VBoxContainer/HBoxContainer/EStatsContainer/damage_dealt.text = str(Stats.damage_dealt)
	$Panel/Panel/VBoxContainer/HBoxContainer/EStatsContainer/damage_taken.text = str(Stats.damage_taken)
	$Panel/Panel/VBoxContainer/HBoxContainer/EStatsContainer/damage_healed.text = str(Stats.damage_healed)
	$Panel/Panel/VBoxContainer/HBoxContainer/EStatsContainer/hits_dealt.text = str(Stats.hits_dealt)
	$Panel/Panel/VBoxContainer/HBoxContainer/EStatsContainer/hits_taken.text = str(Stats.hits_taken)
	$Panel/Panel/VBoxContainer/HBoxContainer/EStatsContainer/bosses_killed.text = str(Stats.bosses_killed)
	$Panel/Panel/VBoxContainer/HBoxContainer/EStatsContainer/enemies_killed.text = str(Stats.enemies_killed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_menu_button_pressed() -> void:
	GameController.clear_run_data()
	GameController.set_phase(GameController.GamePhase.MAIN)
