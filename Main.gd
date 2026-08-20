extends Control

var status: Label

func _ready() -> void:
    status = $UI/Margin/VBox/Status
    status.text = "Extracting addons.zip..."
    await get_tree().process_frame
    var loader := load("res://bootstrap.gd")
    var node := loader.new()
    add_child(node)
    await get_tree().process_frame
    status.text = "addons.zip extracted to user://addons/"

func _on_load_banner_pressed() -> void:
    status.text = "Files extracted. AdMob Editor Plugin still requires the addon under res://addons before export."
func _on_load_interstitial_pressed(): status.text = "Runtime extraction complete."
func _on_show_interstitial_pressed(): status.text = "Runtime extraction complete."
func _on_load_rewarded_pressed(): status.text = "Runtime extraction complete."
func _on_show_rewarded_pressed(): status.text = "Runtime extraction complete."
