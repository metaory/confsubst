#!/bin/bash

# mxc: path=$XDG_CONFIG_HOME/mxc/etc-fzf-opts.mx

# original template ~/dev/meta/confsubst/templates/fzf-opts.sh

# export SKIM_DEFAULT_COMMAND="find . -type f || git ls-tree -r --name-only HEAD || rg --files || find ."
#
# # --header-lines=1
# # --bind "enter:execute(nvim {+})"
# export SKIM_DEFAULT_OPTIONS="
# --height=90%
# --multi
# --ansi
# --prompt='􂨬 '
# --cmd-prompt='􂨩 '
# --inline-info
# --layout=reverse
# --preview='preview {}'
# --preview-window=right:hidden:wrap
# --bind 'ctrl-u:preview-up:10'
# --bind 'ctrl-d:preview-down:10'
# --bind 'tab:toggle+up'
# --bind 'ctrl-y:yank'
# --bind 'ctrl-o:toggle-sort'
# --bind 'ctrl-t:toggle-preview-wrap'
# --bind 'ctrl-x:if-query-empty(abort)+delete-char'
# --color 'matched_bg:#330066,matched:#DD1166,current_match:#330066,current_match_bg:#DD1166,bg+:#4411BB,fg+:#44DDFF,info:#11AA33,prompt:#4400AA,pointer:#88AA00,header:#550099,border:#331166,spinner:#11BB99,query:#11AA33,marker:#88AA00'
# "

export FZF_COMPLETION_AUTO_COMMON_PREFIX=true
export FZF_COMPLETION_AUTO_COMMON_PREFIX_PART=true

export FZF_DEFAULT_OPTS="
--height=90%
--layout=reverse
--info=inline
--ansi
--no-border
--hscroll-off=10
--preview 'preview {}'
--preview-window=right:hidden:wrap
--bind 'ctrl-/:toggle-preview'
--bind 'ctrl-o:toggle-sort'
--bind 'ctrl-y:execute-silent(printf %s {} | xclip -selection clipboard)+abort'
--bind 'ctrl-u:preview-half-page-up'
--bind 'ctrl-d:preview-half-page-down'
--color=gutter:$C00
--color=fg:$XFG,hl:$SBG
--color=fg+:$WFG,bg+:$WBG,hl+:$EBG
--color=info:$CX2,prompt:$CX4,pointer:$CX1
--color=marker:$EBG,spinner:$CX6,header:$CX5"
"

export FZF_CTRL_R_OPTS="
--preview-window=up:3:hidden:wrap
--color header:italic
--header 'Press CTRL-Y to copy command into clipboard'
"

# --preview 'eza --tree --color=always {}'

export FZF_ALT_C_OPTS="
--preview 'preview {}'
--preview-window=right:hidden:wrap
"

export FZF_COMPLETION_OPTS="
--border
"

# vim: ts=2 sts=2 sw=2 ft=bash et

