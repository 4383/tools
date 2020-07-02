# Usage:
# sed -i '' --file rules.sed

# drop previous blank line
s/^import mock/from unittest import mock/
s/^from mock import/from unittest.mock import/
