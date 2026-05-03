#!/bin/sh
# Claude Code statusLine command
# Inspired by starship config: directory + git + model + context

input=$(cat)

# --- Directory (up to 3 path components, like starship truncation_length=3) ---
cwd=$(echo "$input" | jq -r '.cwd // .workspace.current_dir // ""')
home="$HOME"
# Replace home prefix with ~
cwd_display="${cwd/#$home/~}"
# Keep last 3 components
short_dir=$(echo "$cwd_display" | awk -F'/' '{
  n = NF
  if (n <= 3) { print $0 }
  else { print "..." "/" $(n-2) "/" $(n-1) "/" $n }
}')

# --- Git info (skip optional locks) ---
git_branch=""
git_dirty=""
git_repo=""
if git -C "$cwd" --no-optional-locks rev-parse --is-inside-work-tree 2>/dev/null | grep -q true; then
  git_branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null \
    || git -C "$cwd" --no-optional-locks rev-parse --short HEAD 2>/dev/null)
  git_dirty=$(git -C "$cwd" --no-optional-locks status --porcelain 2>/dev/null)
  git_toplevel=$(git -C "$cwd" --no-optional-locks rev-parse --show-toplevel 2>/dev/null)
  git_repo=$(basename "$git_toplevel")
fi

# --- Model ---
model=$(echo "$input" | jq -r '.model.display_name // ""')

# --- Context used ---
remaining=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# --- Rate limits (Claude.ai subscription) ---
five_h_used=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_h_resets=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
seven_d_used=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
seven_d_resets=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')

# --- Helper: format resets_at epoch to human-readable reset time ---
# 5h: if today show HH:MM, else show "Dow HH:MM"
# 1w: always show "Dow HH:MM" (today or future)
format_reset_time_5h() {
  epoch="$1"
  if [ -z "$epoch" ]; then
    return
  fi
  today=$(date +%Y%m%d)
  reset_day=$(date -d "@$epoch" +%Y%m%d 2>/dev/null || date -r "$epoch" +%Y%m%d 2>/dev/null)
  if [ "$reset_day" = "$today" ]; then
    date -d "@$epoch" +%H:%M 2>/dev/null || date -r "$epoch" +%H:%M 2>/dev/null
  else
    date -d "@$epoch" +"%a %H:%M" 2>/dev/null || date -r "$epoch" +"%a %H:%M" 2>/dev/null
  fi
}

format_reset_time_1w() {
  epoch="$1"
  if [ -z "$epoch" ]; then
    return
  fi
  date -d "@$epoch" +"%a %H:%M" 2>/dev/null || date -r "$epoch" +"%a %H:%M" 2>/dev/null
}

# --- Build status line ---
# Colors (ANSI)
BLUE='\033[0;34m'
GRAY='\033[0;37m'
CYAN='\033[0;36m'
YELLOW='\033[0;33m'
WHITE='\033[1;37m'
RESET='\033[0m'

# --- Line 1: Directory, Git repo name, Git branch ---
line1=""

# Directory (blue)
line1="${line1}$(printf "${BLUE}📁 %s${RESET}" "$short_dir")"

# Git repo name (cyan)
if [ -n "$git_repo" ]; then
  line1="${line1}  $(printf "🔀 ${CYAN}%s${RESET}" "$git_repo")"
fi

# Git branch (gray, with * if dirty)
if [ -n "$git_branch" ]; then
  if [ -n "$git_dirty" ]; then
    line1="${line1}  $(printf "${GRAY}🌿 %s${CYAN}*${RESET}" "$git_branch")"
  else
    line1="${line1}  $(printf "${GRAY}🌿 %s${RESET}" "$git_branch")"
  fi
fi

# --- Line 2: Model, Context, Rate limits ---
line2=""

# Model (gray)
if [ -n "$model" ]; then
  line2="${line2}$(printf "${GRAY}🤖 %s${RESET}" "$model")"
fi

# Context used (yellow when high, white otherwise)
if [ -n "$remaining" ]; then
  remaining_int=$(printf "%.0f" "$remaining")
  if [ "$remaining_int" -ge 80 ]; then
    line2="${line2}  $(printf "${YELLOW}📊 %s%%${RESET}" "$remaining_int")"
  else
    line2="${line2}  $(printf "${WHITE}📊 %s%%${RESET}" "$remaining_int")"
  fi
fi

# Rate limits (inline on line 2)
if [ -n "$five_h_used" ]; then
  five_h_pct=$(printf "%.0f" "$five_h_used")
  reset_label=$(format_reset_time_5h "$five_h_resets")
  reset_str=""
  [ -n "$reset_label" ] && reset_str=" (${reset_label})"
  if [ "$five_h_pct" -ge 80 ]; then
    line2="${line2}  $(printf "🪙 ${YELLOW}5h:%s%%%s${RESET}" "$five_h_pct" "$reset_str")"
  else
    line2="${line2}  $(printf "🪙 ${GRAY}5h:%s%%%s${RESET}" "$five_h_pct" "$reset_str")"
  fi
fi
if [ -n "$seven_d_used" ]; then
  seven_d_pct=$(printf "%.0f" "$seven_d_used")
  reset_label=$(format_reset_time_1w "$seven_d_resets")
  reset_str=""
  [ -n "$reset_label" ] && reset_str=" (${reset_label})"
  if [ "$seven_d_pct" -ge 80 ]; then
    line2="${line2}  $(printf "${YELLOW}1w:%s%%%s${RESET}" "$seven_d_pct" "$reset_str")"
  else
    line2="${line2}  $(printf "${GRAY}1w:%s%%%s${RESET}" "$seven_d_pct" "$reset_str")"
  fi
fi

# --- Assemble output ---
line="$line1"
if [ -n "$line2" ]; then
  line="${line}\n${line2}"
fi

printf "%b" "$line"
