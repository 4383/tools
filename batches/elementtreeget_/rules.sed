# Usage:
# sed -i '' --file rules.sed

/^#/! s/getchildren/boom/
#/^#/! {
#/getchildren/ r
#s/getchildren/boom/
#g
        #s&^\(.*[[:space:]]\)\(.*\)getchildren()\(.*\)&\1list(\2)\3&
        #g
#}
#}
#/^#/! s/^\(.*\)\(\.+.*\)getiteraor(\(.*\))\(.*\)/\1\2.iter(\3)\4/g
