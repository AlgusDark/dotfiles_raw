#!/bin/zsh

centered_apps="Finder|Docker Desktop|Meeter|Disk Utility|Activity Monitor|Managed Software Center"
centered_fullheight="Spark"
system_apps="System Preferences|System Information|Calculator|Vimac|The Unarchiver|Hidden Bar|choose|JetBrains Toolbox|Hammerspoon|Raycast|Problem Reporter|Espanso"
JetBrains="IntelliJ IDEA|PyCharm"
line_app="LINE"

apps_with_rules="^(${centered_apps}|${centered_fullheight}|${JetBrains}|${line_app})$"

if [ "${#}" -eq 0 ]; then
  yabai -m rule --add app="^(${centered_apps})$" layer=above manage=off grid=4:4:1:1:2:2
  yabai -m rule --add app="^(${centered_fullheight})$" layer=above manage=off grid=1:6:1:1:4:1
  # yabai -m rule --add app="^(${system_apps})$" sticky=on layer=above manage=off
  # JetBrains principal app has a special title
  # while children popups are normal windows
  yabai -m rule --add app="^(${JetBrains})$" manage=off
  yabai -m rule --add app="^(${JetBrains})$" title="( – )" manage=on
  # Line principal app uses LINE as title
  # while stickers use empty string and everytying else uses a title
  yabai -m rule --add app="^(${line_app})$" title!="^(${line_app})$" manage=off layer=above
  yabai -m rule --add app="^(${line_app})$" title="^$" manage=off layer=above

	# register events
	# for event in window_focused application_activated; do
	# 	yabai -m signal --add label="${0}_${event}" event="${event}" \
	# 		action="${0}"
	# done

  yabai -m signal --add label="global_default_window_created" event="window_created" action="zsh ${0}"

	# when loading the script, convert all existing splits to horizontal
	yabai -m query --windows \
		| jq -r --arg apps "$apps_with_rules" '.[] | select((.app | (test($apps) | not)) and (."can-resize" or ."can-move") and ."is-floating").id' \
		| xargs -I{} yabai -m window {} --toggle float --layer below
	exit
fi

shouldBeTiled=$(yabai -m query --windows --window "$YABAI_WINDOW_ID" \
  | jq -e --arg apps "$apps_with_rules" '(test($apps) | not) and (."can-resize" or ."can-move") and ."is-floating"')

# pm="(a|b|c)"
# if [[ "$pm" =~ "c" ]]; then echo true; else echo false; fi

if [ "$shouldBeTiled" = true ]
then
  yabai -m window "$YABAI_WINDOW_ID" --toggle float --layer below
fi