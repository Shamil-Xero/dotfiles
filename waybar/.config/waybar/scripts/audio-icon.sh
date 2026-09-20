#!/usr/bin/env bash
# audio-icon.sh — Waybar JSON with context-aware audio icon

VOLUME_LINE=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null)

if echo "$VOLUME_LINE" | grep -q "MUTED"; then
  MUTED=true
else
  MUTED=false
fi

VOL_RAW=$(echo "$VOLUME_LINE" | grep -oP '[\d.]+' | head -1)
VOL_PCT=$(awk "BEGIN { printf \"%d\", ${VOL_RAW:-0} * 100 }")

# Active default sink: line containing '*' and '[vol:'
SINK_NAME=$(wpctl status 2>/dev/null \
  | grep -F '[vol:' \
  | grep -F '*' \
  | grep -v 'Source\|Input\|capture' \
  | head -1 \
  | sed 's/.*\*\s*[0-9]*\.\s*//' \
  | sed 's/\s*\[.*//' \
  | xargs)

pick_icon() {
  local name="${1,,}"

  if $MUTED; then
    echo ""; return
  fi

  if echo "$name" | grep -qiE "buds?|earbuds?|tws"; then
    echo ""          # earbuds / TWS
  elif echo "$name" | grep -qiE "headset"; then
    echo "󱡏"         # headset (mic)
  elif echo "$name" | grep -qiE "headphone|wh-|wf-|airpods?|galaxy buds?"; then
    echo ""          # over-ear headphones
  elif echo "$name" | grep -qiE "bluetooth|bluez|jbl|sony|bose|marshall|anker|soundcore|ultimate ears"; then
    echo "󰂰"         # bluetooth speaker
  elif echo "$name" | grep -qiE "hdmi|display"; then
    echo "󰡁"         # TV / monitor
  else
    # Wired speaker — volume-stepped icons
    if   [ "$VOL_PCT" -eq 0 ];   then echo "󰝟"
    elif [ "$VOL_PCT" -le 33 ];  then echo ""
    elif [ "$VOL_PCT" -le 66 ];  then echo ""
    else                              echo ""
    fi
  fi
}

ICON=$(pick_icon "$SINK_NAME")
TOOLTIP="$([ "$MUTED" = true ] && echo "Muted" || echo "$VOL_PCT%") — ${SINK_NAME:-Unknown}"

printf '{"text": "%s ", "tooltip": "%s", "percentage": %d, "class": "%s"}\n' \
  "$ICON" "$TOOLTIP" "$VOL_PCT" \
  "$([ "$MUTED" = true ] && echo 'muted' || echo 'active')"
