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
alias lw="ls -A| wl"
alias cx="chmod ug+x"
alias findx="find . -path '*.svn*' -prune -o -type f -print0 | xargs -0 grep -i -P "
alias grepf="find . -path '*.svn*' -prune -o -type f -print | grep -i "
alias grepp="grep -P " ## perl
alias rest="cd;clear"

## redoing basic commands

alias mv="mv -i"
alias cp="cp -i"
alias mc="echo nope"
alias more="less"
## I think this is also defined in some system default
alias which='alias | /usr/bin/which --tty-only --read-alias --show-dot --show-tilde'


## set a proxy for curls
#export http_proxy="http://1234:linux@proxy:8080"

## system debugging help

alias dusk="du -sk * 2>/dev/null | sort -rn"
alias myps="ps -eo user,pid,etime,fname,args | grep ^$USER | grep -v ' ps ' | grep -v ' grep $USER'"
alias dirsize="du -h * | perl -ne'print if m,\t[^/]+$,'"

## software debugging help

alias mypath="echo \$PATH | sed 's/:/\n/g'"
alias long_lines="perl -nle's/.{0,80}//; if (\$_) { print qq{\$.: \$_} }'"
alias crongrep="crontab -l | grep"
alias remove_tabs="perl -i -pe's/\t/    /g'"
## find 100+ line perl subroutines. note, does not work with Moose stuff.
alias find_long_subs='perl -nE'\''BEGIN{$a=1 if @ARGV>1}if(/^sub (\w+)\b/){$subs{($a?"${ARGV}::":"").$sub}=$c if $c>=100;$sub=$1;$c=0}else{$c++}END{say "$subs{$_}\t$_"foreach sort keys %subs}'\'''
## print line number and color code
alias list_colors_in_css="grep -n color \$1 | perl -F'\s|:' -anle'/(#[\da-fA-F]{3,6})/; print qq{\$F[0] \$1}' "

## get all SVN commits after a certain date by a certain user
## e.g. $ svn_date_user 2013-01-31 jmcguire
svn_date_user () {
    svn log -v -r{$1}:HEAD | sed -n "/$2/,/-----\$/ p"
}

## get breakpoints from a CSS file
## e.g. $ get_css_breakpoints time.css
get_css_breakpoints () {
    grep ^@media $1 \
    | perl -pe's/\@media screen and \(([^)]+)\) {/$1/' \
    | perl -pe's/^\@media(?: (?:only )?screen and )?//;
               s/,\s*/\n/g;
               s/only screen and//g;
               s/^\s+//mg;
               s/ {\s*$/\n/mg;' \
    | sort -u
}

## liaison-specific schtick

alias ptidy='perl -MPerl::Tidy -E'\''Perl::Tidy::perltidy(source=>$ARGV[1],perltidyrc=>"~/.perltidyrc")'\'''
## run this while in a template directory, no arguments are needed
alias template_structure="find . -path '*.svn*' -prune -o -type f -print0 | xargs -0 perl -nle'(\$inc) = /\\[\\%-? \\s* INCLUDE \\s+ .([\\w\\.\\/-]+). \\s*/x; next unless \$inc; \$all{\$ARGV}{\$inc} = 1; END{print qq{\\n\$_:\\n\\t} . join(qq{\\n\\t}, keys %{\$all{\$_}}) foreach keys %all}'"
## run this while in a template directory, no arguments are needed
alias find_css_in_templates="find . -path '*.svn*' -prune -o -type f -print0 | xargs -0 perl -nle'map {\$a=\$1; next if \$2 =~ /[\\[\\]\\%]/; print qq{\$ARGV\\t} . (lc \$a eq qq{id} ? qq{#\$_} : qq{.\$_})} split /\\s/, \$2 while(/(class|id)=\"([^\"]+)\"/g)'"
## kill rogue catalyst servers (after bash crashes)
alias kill_server='myps | grep _server.pl | grep -v grep | awk '\''{print $2}'\'' | xargs kill -9 '

