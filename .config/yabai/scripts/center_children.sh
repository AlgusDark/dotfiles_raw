#!/bin/bash

PID=$(yabai -m query --windows --window $YABAI_WINDOW_ID | jq '.pid')
FLOAT=$(
  yabai -m query --windows | jq -rc 'map(select(.pid == '$PID'))
  | if length > 1 then 
    (
      sort_by(.id)
      | .[0] as $parent
      | .[length-1] as $children
      | [(($parent.frame.x + $parent.frame.w)/2 | floor), (($parent.frame.y + $parent.frame.h)/2 | floor), (($children.frame.x + $children.frame.w)/2 | floor), (($children.frame.y + $children.frame.h)/2 | floor)]
    )
  else false end
')

if [ "$FLOAT" = false ]; then
 exit
fi

data=()
while read -r value
do
  data+=("$value")
done < <(echo "$FLOAT" | jq -c '.[]')

echo "test --- $FLOAT --- ${data[0]} --- $PID"