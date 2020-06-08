# Usage:
# sed -i '' --file rules.sed

# drop previous blank line
/abandon/a label-Backport-Candidate = -2..+2 group oslo-core\nlabel-Backport-Candidate = -1..+1 group Registered Users

/receive/s/^/[label "Backport-Candidate"]\ncopyAllScoresIfNoCodeChange = true\ncopyAllScoresOnTrivialRebase = true\ncopyMaxScore = true\ncopyMinScore = true\ndefaultValue = 0\nfunction = NoBlock\nvalue = -2 Do Not Backport\nvalue = -1 Not A Backport Candidate\nvalue = 0 Backport Review Needed\nvalue = +1 Proposed Backport\nvalue = +2 Should Backport\n/
