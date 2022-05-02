PROMPT='%{$fg_bold[green]%}%n@%m%{$reset_color%}'
PROMPT+=' %{$fg_bold[blue]%}%~%{$reset_color%} $(git_prompt_info)%{$reset_color%}'
PROMPT+='%B»%b '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[white]%}✗%{$fg[yellow]%}) "
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[yellow]%}) "

