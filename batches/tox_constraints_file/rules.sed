# Usage:
# sed -i '' --file rules.sed

#/\[testenv:venv\]/i \\n[testenv:pre-commit]\ndeps =\n  pre-commit\ncommands =\n pre-commit run --from-ref HEAD^ --to-ref HEAD\n\n
s/UPPER_CONSTRAINTS_FILE/TOX_CONSTRAINTS_FILE/
