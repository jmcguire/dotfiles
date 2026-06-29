#!/bin/sh

## common tasks

alias ..="cd .."
alias ...="cd ../.."
alias wl="wc -l"
alias l="ls -lAFhGo"
#alias l="ls -lAF --group-directories-first --human-readable"
#l() { ls -lAFhG $* | grep -ve '\.\<\(DS_Store\|localized\)\>'; }
alias l1="ls -1"
alias lw="ls -A| wl"
alias cx="chmod ug+x"
# 24 filenames on a line, 4 simultaneous processes
alias findx="find . -path '*.svn*' -prune -o -type f -print0 | xargs -0 -n24 -P4 grep -i -E "
alias grepf="find . -path '*.svn*' -prune -o -type f -print | grep -i "
grepp() {
    if printf 'x\n' | grep -P 'x' >/dev/null 2>&1; then
        grep -P "$@"
    elif have ggrep && printf 'x\n' | ggrep -P 'x' >/dev/null 2>&1; then
        ggrep -P "$@"
    else
        echo "grep -P is not available; install GNU grep if you need grepp" >&2
        return 1
    fi
}
alias rest="cd;clear"
#alias g="git"
alias k9="kill -9"
alias space='printf "\n\n\n\n\n\n"'

## redoing basic commands

alias mv="mv -i"
alias cp="cp -i"
alias mc="echo nope"
alias more="less --quit-if-one-screen"
## I think this is also defined in some system default
#alias which='alias | /usr/bin/which --tty-only --read-alias --show-dot --show-tilde'

## set a proxy for curls
#export http_proxy="http://1234:linux@proxy:8080"

## system debugging help

alias dusk="du -sk * 2>/dev/null | sort -rn"
myps() {
    ps fux "$@" 2>/dev/null || ps aux "$@"
}
alias dirsize="du -h * | perl -ne'print if m,\t[^/]+$,'"
alias all_permissions="ls -lR . | awk '{print \$1}' | sort -u | grep -v total | grep -v '^\\./'"
alias list_extensions='ls | perl -nE'\''next unless /\.([^.]*)$/; print $1'\'' | sort | uniq -c | sort -rn'
alias find_files="find . -type f -print"

# srvi - for editing a file as root maintaining vi customizations
if have sr; then
    alias srvi='sr env HOME="$HOME" $EDITOR'
elif have sudo; then
    alias srvi='sudo env HOME="$HOME" $EDITOR'
fi

srsu() {
    if have sr; then
        root_cmd=sr
    elif have sudo; then
        root_cmd="sudo -E"
    elif have su; then
        root_cmd="su -m root"
    else
        echo "no root escalation command found" >&2
        return 1
    fi

    case "$(basename "$SHELL")" in
        bash) $root_cmd env "$SHELL" --rcfile "$HOME/.bash_profile" ;;
        *) $root_cmd env "$SHELL" ;;
    esac
}

## software debugging help

alias mypath="echo \$PATH | sed 's/:/\n/g'"
alias long_lines="perl -nle's/.{0,80}//; if (\$_) { print qq{\$.: \$_} }'"
alias crongrep="crontab -l | grep"
alias tabs_to_spaces="perl -i -pe's/\t/    /g'"
alias spaces_to_tabs="perl -i -pe's/\G[ ]{4}/\t/g'"
## print line number and color code
list_colors_in_css() {
    grep -n color "$@" | perl -F'\s|:' -anle'/(#[\da-fA-F]{3,6})/; print qq{$F[0] $1}'
}
alias git_branch_changes='for k in `git branch | perl -pe s/^..//`; do echo -e `git show --pretty=format:"%Cgreen%ci %Cblue%cr%Creset" $k -- | head -n 1`\\t$k; done | sort -r'
alias start_server="python3 -m http.server 8000"
alias py_compile="python3 -m py_compile"
# get list of objects and functions in a python file
alias python_structure="perl -ne'print if /\\b(?<!:)(class|def)\\s/'"
alias remove_wide_characters="perl -pe's/[^\x00-\x7f]//g;'" # for grepping: unicode, utf8, utf-8
alias git_lines_coded="git diff -- ':!*.json' | egrep '^(\+|-)' | wc -l"

## perl

## list of all perl libraries in use, starting from current folder, ordered by most used. parameter: none, uses current directory and children
alias perl_libraries="find . -name '*pm' -print | grep -v _Test.pm | xargs egrep '^\s*(require|use)\b' | grep -v constant | cut -d: -f2- | sed 's/^[ \t]*//' | sed 's/ qw.*$/;/g' | perl -ne'print unless /use [a-z]/' | sort | uniq -c | sort -rn"
## show the broad structure of a perl file, parameter: filename
alias perl_code_structure="perl -ne'print if /^[^#]*(?<!\\$)\b(sub|if|elsif|else|for|foreach|while|unless|until|do|next|last|redo|continue|given|when|goto|return|die|try|catch|return)\b/'"
## find subs greater than 100 lines, parameter: filename
alias perl_find_long_subs='perl -nE'\''BEGIN{$a=1 if @ARGV>1}if(/^sub (\w+)\b/){$subs{($a?"${ARGV}::":"").$sub}=$c if $c>=100;$sub=$1;$c=0}else{$c++}END{say "$subs{$_}\t$_"foreach sort keys %subs}'\'''
alias update_perl='curl -L http://xrl.us/installperlosx | bash'

## misc fun

alias sumup="awk '{total = total + \$1} END {print total}'"
random_user() {
    users | tr ' ' '\n' | awk 'NF' | sort -u | awk 'BEGIN{srand()} {u[NR]=$0} END{if(NR) print u[int(rand()*NR)+1]}'
}
alias weather="curl wttr.in/NATICK"
alias quick_weather="curl 'wttr.in/NATICK?format=%l:%c%t:%f:%m\n'"
if have mdless; then
    alias readm=mdless
elif have glow; then
    alias readm=glow
fi
alias preview="qlmanage -p"
