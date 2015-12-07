a='s/_/ /g;'                     # turn underlines to spaces
b='s/_\d{6,}\.cbz/.cbz/;'        # get rid of that trailing hash
c='s/([a-z])([A-Z])/$1 $2/g;'    # separate out camel case
d='s/ issue / /;'                # remove the issue word, which is almost always not needed
e='s/\b([a-z])/\U$1/g;'          # add capitals
k='s/\.([A-Z])/.\L$1/g;'         # except for the extension
f='s/([^\d])(\d+)\./$1 - $2./g;' # separate out numbering
g='s/vol(\d)/ - v$1/i;'          # my prefered volumne nomenclature
h='s/ vol - (\d)/ - v$1/i;'      # more of the same
i='s/(v\d)([^.])/$1 - $2/;'      # and push out anything after the volume number
j='s/  / /g;'                    # keep this at the end, get rid of double spaces

rename "$b $a $c $d $e $k $f $g $h $i $j" $*

