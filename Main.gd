extends Control

# Google test ad unit IDs. Replace these only after your AdMob app is configured.
const BANNER_ID := "ca-app-pub-3940256099942544/6300978111"
const INTERSTITIAL_ID := "ca-app-pub-3940256099942544/1033173712"
const REWARDED_ID := "ca-app-pub-3940256099942544/5224354917"

var banner_ad: AdView
var interstitial_ad: InterstitialAd
var rewarded_ad: RewardedAd

var interstitial_callback := InterstitialAdLoadCallback.new()
var rewarded_callback := RewardedAdLoadCallback.new()

@onready var status_label: Label = $UI/Margin/VBox/Status
@onready var reward_label: Label = $UI/Margin/VBox/Reward


func _ready() -> void:
	status_label.text = "Initializing AdMob..."

	if OS.get_name() != "Android" and OS.get_name() != "iOS":
		status_label.text = "Run this project on Android/iOS to display ads."
		return

	interstitial_callback.on_ad_loaded = func(ad: InterstitialAd) -> void:
		interstitial_ad = ad
		status_label.text = "Interstitial loaded."

	interstitial_callback.on_ad_failed_to_load = func(error: LoadAdError) -> void:
		status_label.text = "Interstitial failed: " + error.message

	rewarded_callback.on_ad_loaded = func(ad: RewardedAd) -> void:
		rewarded_ad = ad
		status_label.text = "Rewarded loaded."

	rewarded_callback.on_ad_failed_to_load = func(error: LoadAdError) -> void:
		status_label.text = "Rewarded failed: " + error.message

	var listener := OnInitializationCompleteListener.new()
	listener.on_initialization_complete = func(_status: InitializationStatus) -> void:
		status_label.text = "AdMob initialized."
		load_banner()

	MobileAds.initialize(listener)


func load_banner() -> void:
	if banner_ad:
		banner_ad.destroy()
		banner_ad = null

	banner_ad = AdView.new(BANNER_ID, AdSize.BANNER, AdPosition.BOTTOM)
	banner_ad.load_ad(AdRequest.new())
	status_label.text = "Banner requested."


func load_interstitial() -> void:
	interstitial_ad = null
	status_label.text = "Loading interstitial..."
	InterstitialAdLoader.new().load(
		INTERSTITIAL_ID,
		AdRequest.new(),
		interstitial_callback
	)


func show_interstitial() -> void:
	if interstitial_ad:
		interstitial_ad.show()
		interstitial_ad = null
		status_label.text = "Interstitial shown."
	else:
		status_label.text = "Interstitial is not loaded yet."


func load_rewarded() -> void:
	rewarded_ad = null
	status_label.text = "Loading rewarded..."
	RewardedAdLoader.new().load(
		REWARDED_ID,
		AdRequest.new(),
		rewarded_callback
	)


func show_rewarded() -> void:
	if not rewarded_ad:
		status_label.text = "Rewarded is not loaded yet."
		return

	var reward_listener := OnUserEarnedRewardListener.new()
	reward_listener.on_user_earned_reward = func(reward: RewardedItem) -> void:
		reward_label.text = "Reward received: %d %s" % [reward.amount, reward.type]

	rewarded_ad.show(reward_listener)
	rewarded_ad = null
	status_label.text = "Rewarded shown."


func _on_load_banner_pressed() -> void:
	load_banner()


func _on_load_interstitial_pressed() -> void:
	load_interstitial()


func _on_show_interstitial_pressed() -> void:
	show_interstitial()


func _on_load_rewarded_pressed() -> void:
	load_rewarded()


func _on_show_rewarded_pressed() -> void:
	show_rewarded()


func _exit_tree() -> void:
	if banner_ad:
		banner_ad.destroy()
		banner_ad = null
