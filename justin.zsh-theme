function prompt_emergency_note() {
    # if any of my scripts puts a not into ~/.emergency_alert, then it will be displayed
    # on every prompt. it's a real ad-hoc method to get my attention, but meh.
    # BROKEN
    if [[ -r ~/.emergency_note ]]; then
        echo "%{$fg_bold[red]%}HELLO%{$reset_color%}${ZSH_NEWLINE}"
    fi
}

function prompt_python_venv() {
    # for getting the python venv into a PS1
    if [ $VIRTUAL_ENV ]; then
        venv_name=`basename $VIRTUAL_ENV`
        python_version=`$VIRTUAL_ENV/bin/python --version | sed 's,Python ,,'`

        echo "%{$fg[green]%}($venv_name $python_version)%{$reset_color%} "
    fi
}

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[white]%}✗%{$fg[yellow]%}) "
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[yellow]%}) "

ZSH_NEWLINE=$'\n'

setopt PROMPT_SUBST

# \033 is the escape character
# [38; is forgraound
# [48; is background
# 2, is 24 bit color

# m marks the end of the sequence

PROMPT=""
PROMPT+='%{$fg_bold[green]%}%n@%m%{$reset_color%}'
PROMPT+=' %{$fg_bold[blue]%}%~%{$reset_color%}'
PROMPT+=' $(git_prompt_info)'
PROMPT+='$(prompt_python_venv)'
PROMPT+=$'\n''%B»%b '


