# Usage:
# sed -i '' --file rules.sed

# replace bandit version
s/bandit>=.* # Apache-2.0/bandit>=1.6.0,<1.7.0 # Apache-2.0/g
