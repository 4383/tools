# Usage:
# sed -i '' --file rules.sed

# drop previous blank line
/^[[:space:]]*$/{N;/\nfrom __future__/s/^.*\n//}

# drop all future imports
/^from __future__ */d
