#!/bin/bash

## alias management

alias list_aliases='cat ~/.bash_aliases'
alias edit_aliases='vi ~/.bash_aliases; echo "Refreshing aliases"; source ~/.bash_aliases'
alias refresh_aliases='source ~/.bash_aliases'

## common tasks

alias ..="cd .."
alias ...="cd ../.."
alias wl="wc -l"
alias l="ls -lAFh"
#alias l="ls -lAF --group-directories-first --human-readable"
#l() { ls -lAFhG $* | grep -ve '\.\<\(DS_Store\|localized\)\>'; }
alias l1="ls -1"
alias lw="ls -A| wl"
alias cx="chmod ug+x"
alias findx="find . -path '*.svn*' -prune -o -type f -print0 | xargs -0 grep -i -E "
alias grepf="find . -path '*.svn*' -prune -o -type f -print | grep -i "
alias grepp="grep -P " ## perl
alias rest="cd;clear"
#alias g="git"
alias k9="kill -9"

## redoing basic commands

alias mv="mv -i"
alias cp="cp -i"
alias mc="echo nope"
alias more="less"
## I think this is also defined in some system default
#alias which='alias | /usr/bin/which --tty-only --read-alias --show-dot --show-tilde'

## set a proxy for curls
#export http_proxy="http://1234:linux@proxy:8080"

## system debugging help
alias dusk="du -sk * 2>/dev/null | sort -rn"
alias myps="ps fux"
alias dirsize="du -h * | perl -ne'print if m,\t[^/]+$,'"
alias all_permissions="ls -lR . | awk '{print \$1}' | sort -u | grep -v total | grep -v '^\\./'"
alias list_extensions='ls | perl -nE'\''next unless /\.([^.]*)$/; print $1'\'' | sort | uniq -c | sort -rn'
alias find_files="find . -type f -print"

## software debugging help

alias mypath="echo \$PATH | sed 's/:/\n/g'"
alias long_lines="perl -nle's/.{0,80}//; if (\$_) { print qq{\$.: \$_} }'"
alias crongrep="crontab -l | grep"
alias tabs_to_spaces="perl -i -pe's/\t/    /g'"
alias spaces_to_tabs="perl -i -pe's/\G[ ]{4}/\t/g'"
## find 100+ line perl subroutines. note, does not work with Moose stuff.
## print line number and color code
alias list_colors_in_css="grep -n color \$1 | perl -F'\s|:' -anle'/(#[\da-fA-F]{3,6})/; print qq{\$F[0] \$1}' "
alias git_branch_changes='for k in `git branch | perl -pe s/^..//`; do echo -e `git show --pretty=format:"%Cgreen%ci %Cblue%cr%Creset" $k -- | head -n 1`\\t$k; done | sort -r'
alias start_server="python -m SimpleHTTPServer 8000"
alias py_compile="python -m py_compile"
# get list of objects and functions in a python file
alias python_structure="perl -ne'print if /\\b(?<!:)(class|def)\\s/'"
alias remove_wide_characters="perl -pe's/[^\x00-\x7f]//g;'" # for grepping: unicode, utf8, utf-8

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
alias to_json="p1 -MJSON::XS -MData::Dumper -nE'print Dumper JSON::XS::decode_json(\$_)'"
alias random_user="users | sed -r -e 's/ /\n/g' | sort -u | shuf -n 1"
alias myweather="curl wttr.in/NATICK"

