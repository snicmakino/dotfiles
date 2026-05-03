#!/bin/bash
# Claude Code Notification

kernel=$(uname -r)
case "$kernel" in
  *microsoft*|*Microsoft*)
    powershell.exe -NonInteractive -WindowStyle Hidden -Command "[System.Media.SystemSounds]::Asterisk.Play()" ;;
  *)
    case "$(uname -s)" in
      Darwin)
        afplay /System/Library/Sounds/Funk.aiff 2>/dev/null ;;
      Linux)
        if command -v notify-send >/dev/null 2>&1; then
          notify-send "Claude Code" "" --urgency=normal
        elif command -v paplay >/dev/null 2>&1; then
          paplay /usr/share/sounds/freedesktop/stereo/complete.oga 2>/dev/null
        fi ;;
    esac ;;
esac
