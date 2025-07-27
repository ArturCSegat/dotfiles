#     ____      ____
#    / __/___  / __/
#   / /_/_  / / /_
#  / __/ / /_/ __/
# /_/   /___/_/ key-bindings.zsh

# Key bindings
# ------------

if 'zmodload' 'zsh/parameter' 2>'/dev/null' && (( ${+options} )); then
  __fzf_key_bindings_options="options=(${(j: :)${(kv)options[@]}})"
else
  () {
    __fzf_key_bindings_options="setopt"
    'local' '__fzf_opt'
    for __fzf_opt in "${(@)${(@f)$(set -o)}%% *}"; do
      if [[ -o "$__fzf_opt" ]]; then
        __fzf_key_bindings_options+=" -o $__fzf_opt"
      else
        __fzf_key_bindings_options+=" +o $__fzf_opt"
      fi
    done
  }
fi

'builtin' 'emulate' 'zsh' && 'builtin' 'setopt' 'no_aliases'

{
if [[ -o interactive ]]; then

__fzf_defaults() {
  echo -E "--height ${FZF_TMUX_HEIGHT:-40%} --min-height 20+ --bind=ctrl-z:ignore $1"
  command cat "${FZF_DEFAULT_OPTS_FILE-}" 2> /dev/null
  echo -E "${FZF_DEFAULT_OPTS-} $2"
}

__fzf_select() {
  setopt localoptions pipefail no_aliases 2> /dev/null
  local item
  FZF_DEFAULT_COMMAND=${FZF_CTRL_T_COMMAND:-} \
  FZF_DEFAULT_OPTS=$(__fzf_defaults "--reverse --walker=file,dir,follow,hidden --scheme=path" "${FZF_CTRL_T_OPTS-} -m") \
  FZF_DEFAULT_OPTS_FILE='' fzf "$@" < /dev/tty | while read -r item; do
    echo -n -E "${(q)item} "
  done
  local ret=$?
  echo
  return $ret
}

fzf-file-widget() {
  LBUFFER="${LBUFFER}$(__fzf_select)"
  local ret=$?
  zle reset-prompt
  return $ret
}
if [[ "${FZF_CTRL_T_COMMAND-x}" != "" ]]; then
  zle     -N            fzf-file-widget
  bindkey -M emacs '^T' fzf-file-widget
  bindkey -M vicmd '^T' fzf-file-widget
  bindkey -M viins '^T' fzf-file-widget
fi

# ALT-C - cd into directory and open Zellij session
fzf-cd-widget() {
  setopt localoptions pipefail no_aliases 2> /dev/null

  local dir="$(
    FZF_DEFAULT_COMMAND=${FZF_ALT_C_COMMAND:-} \
    FZF_DEFAULT_OPTS=$(__fzf_defaults "--reverse --walker=dir,follow,hidden --scheme=path" "${FZF_ALT_C_OPTS-} +m") \
    FZF_DEFAULT_OPTS_FILE='' fzf < /dev/tty
  )"

  if [[ -z "$dir" ]]; then
    zle redisplay
    return 0
  fi

  zle push-line

  local absdir="${(q)dir:a}"
  local session_name="${${absdir:t}//[^A-Za-z0-9]/_}"

  BUFFER="
cd -- $absdir
if zellij list-sessions | grep -q \"$session_name\"; then
  # Attach will resurrect a dead session if needed
  zellij attach \"$session_name\" 
else
	zellij --session \"$session_name\" --new-session-with-layout ~/.config/zellij/layout.kdg
fi
"
  zle accept-line

  local ret=$?
  unset dir absdir session_name
  zle reset-prompt
  return $ret
}

#
#
if [[ "${FZF_ALT_C_COMMAND-x}" != "" ]]; then
  zle     -N             fzf-cd-widget
  bindkey -M emacs '\ec' fzf-cd-widget
  bindkey -M vicmd '\ec' fzf-cd-widget
  bindkey -M viins '\ec' fzf-cd-widget
fi

fzf-history-widget() {
  local selected
  setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases noglob nobash_rematch 2> /dev/null
  if zmodload -F zsh/parameter p:{commands,history} 2>/dev/null && (( ${+commands[perl]} )); then
    selected="$(printf '%s\t%s\000' "${(kv)history[@]}" |
      perl -0 -ne 'if (!$seen{(/^\s*[0-9]+\**\t(.*)/s, $1)}++) { s/\n/\n\t/g; print; }' |
      FZF_DEFAULT_OPTS=$(__fzf_defaults "" "-n2..,.. --scheme=history --bind=ctrl-r:toggle-sort --wrap-sign '\t↳ ' --highlight-line ${FZF_CTRL_R_OPTS-} --query=${(qqq)LBUFFER} +m --read0") \
      FZF_DEFAULT_OPTS_FILE='' fzf)"
  else
    selected="$(fc -rl 1 | awk '{ cmd=$0; sub(/^[ \t]*[0-9]+\**[ \t]+/, "", cmd); if (!seen[cmd]++) print $0 }' |
      FZF_DEFAULT_OPTS=$(__fzf_defaults "" "-n2..,.. --scheme=history --bind=ctrl-r:toggle-sort --wrap-sign '\t↳ ' --highlight-line ${FZF_CTRL_R_OPTS-} --query=${(qqq)LBUFFER} +m") \
      FZF_DEFAULT_OPTS_FILE='' fzf)"
  fi
  local ret=$?
  if [ -n "$selected" ]; then
    if [[ $(awk '{print $1; exit}' <<< "$selected") =~ ^[1-9][0-9]* ]]; then
      zle vi-fetch-history -n $MATCH
    else
      LBUFFER="$selected"
    fi
  fi
  zle reset-prompt
  return $ret
}
zle     -N            fzf-history-widget
bindkey -M emacs '^R' fzf-history-widget
bindkey -M vicmd '^R' fzf-history-widget
bindkey -M viins '^R' fzf-history-widget
fi

} always {
  eval $__fzf_key_bindings_options
  unset __fzf_key_bindings_options
}

