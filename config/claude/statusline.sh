#!/usr/bin/env bash
input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // empty')
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')
ctx_pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0')
rate5h=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // 0')
rate7d=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
reset5h=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
reset7d=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')

# ANSI 基本色のみを使う。実際の色は端末のカラースキーマが決めるため、
# WezTerm のテーマを変えると statusline も追従する
DIM=$'\033[2m'
RESET=$'\033[0m'
GREEN=$'\033[32m'
YELLOW=$'\033[33m'
RED=$'\033[31m'
BLUE=$'\033[34m'
MAGENTA=$'\033[35m'
CYAN=$'\033[36m'

SEP="${DIM} | ${RESET}"

# 使用率に応じて色を変える（50%未満:緑 / 80%未満:黄 / 以上:赤）
color_pct() {
  local pct=${1%%.*}
  if [ "${pct:-0}" -ge 80 ]; then
    printf '%s' "$RED"
  elif [ "${pct:-0}" -ge 50 ]; then
    printf '%s' "$YELLOW"
  else
    printf '%s' "$GREEN"
  fi
}

# リセット時刻を絶対時刻で返す。当日なら HH:MM、日付が変わるなら M/D HH:MM。
# 残り時間ではなく絶対時刻にすることで、再描画されない間も表示が古くならない
fmt_reset() {
  local target=$1
  [ -z "$target" ] && return
  [ "$target" -le "$(date +%s)" ] && return
  if [ "$(date -d "@$target" +%F)" = "$(date +%F)" ]; then
    date -d "@$target" +%H:%M
  else
    date -d "@$target" +%-m/%-d\ %H:%M
  fi
}

# git status は大きなリポジトリで遅いため5秒キャッシュする
git_cache="${TMPDIR:-/tmp}/claude-statusline-git-$(echo "$cwd" | md5sum | cut -c1-16)"
if [ -f "$git_cache" ] && [ $(($(date +%s) - $(stat -c %Y "$git_cache" 2>/dev/null || echo 0))) -lt 5 ]; then
  read -r git_branch git_dirty < "$git_cache"
else
  # --no-optional-locks は git 本体のオプション。サブコマンドに渡すと失敗する
  git_branch=$(git --no-optional-locks -C "$cwd" branch --show-current 2>/dev/null)
  git_dirty=""
  if [ -n "$git_branch" ]; then
    [ -n "$(git --no-optional-locks -C "$cwd" status --porcelain 2>/dev/null)" ] && git_dirty="*"
  fi
  printf '%s %s\n' "$git_branch" "$git_dirty" > "$git_cache"
fi

short_cwd=$(echo "$cwd" | sed "s|^$HOME|~|" | rev | cut -d/ -f1-3 | rev)

parts=""
[ -n "$model" ] && parts="${CYAN}${model}${RESET}"
if [ -n "$git_branch" ]; then
  parts="${parts:+${parts}${SEP}}${MAGENTA}${git_branch}${RESET}${YELLOW}${git_dirty}${RESET}"
fi
parts="${parts:+${parts}${SEP}}${BLUE}${short_cwd}${RESET}"
parts="${parts}${SEP}${DIM}ctx${RESET} $(color_pct "$ctx_pct")${ctx_pct}%${RESET}"

rate="${DIM}5h${RESET} $(color_pct "$rate5h")${rate5h}%${RESET}"
at5h=$(fmt_reset "$reset5h")
[ -n "$at5h" ] && rate="${rate} ${DIM}@${at5h}${RESET}"
parts="${parts}${SEP}${rate}"

if [ -n "$rate7d" ]; then
  pct7d=$(printf '%.0f' "$rate7d")
  rate="${DIM}7d${RESET} $(color_pct "$pct7d")${pct7d}%${RESET}"
  at7d=$(fmt_reset "$reset7d")
  [ -n "$at7d" ] && rate="${rate} ${DIM}@${at7d}${RESET}"
  parts="${parts}${SEP}${rate}"
fi

printf '%s\n' "$parts"
