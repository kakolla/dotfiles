really janky flow cuz the notch messes switching from clamshell to  regular mode and system_profiler doesnt expose a switching event

# currently
hammerspoon - screen watcher captures monitor change -> restart sketchybar
sketchybar - execute display_mode.sh (change offset size for notch depending on clamshell/laptop), reload aerospace
aerospace - clamshell (32 from top), regular (0 from top)
