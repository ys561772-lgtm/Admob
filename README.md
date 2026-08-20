# Godot 4.7 AdMob — Compressed Addon + Automatic Bootstrap

The real AdMob addon is stored as `addons.zip` instead of an expanded `addons/admob` directory.

When the project is opened in Godot 4.7:

1. The small `AdMob Bootstrap` editor plugin runs.
2. It uses Godot's `ZIPReader` API to extract `addons.zip` into `res://addons/`.
3. It scans the filesystem.
4. It enables the `admob` editor plugin programmatically through `EditorInterface.set_plugin_enabled()`.
5. It saves the plugin-enabled setting.

This is an **editor/build-time bootstrap**, not a runtime trick: an exported Android app has a read-only `res://`, so the addon must be unpacked before the APK is exported.

The project keeps Google's test AdMob IDs from the original starter. Replace them only when you are ready to configure your own AdMob app.


## Runtime extraction
`addons.zip` is kept at the project root. On Run, `bootstrap.gd` extracts it to `user://addons/`. This is intentionally runtime-only. Godot Editor plugins and Android native plugin integration must be present under `res://addons` during editor/export time; a runtime-extracted copy cannot retroactively register an EditorPlugin or native Android build plugin.
