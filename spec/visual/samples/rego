package httpapi.authz

subordinates = {"alice": [], "charlie": [], "bob": ["alice"], "betty": ["charlie"]}

# HTTP API request
import input
# input = {
#   "path": ["finance", "salary", "alice"],
#   "user": "alice",
#   "method": "GET"
# }

default allow = false

# Allow users to get their own salaries.
allow {
  input.method = "GET"
  input.path = ["finance", "salary", username]
  input.user == username
}

# Allow managers to get their subordinates' salaries.
allow {
  input.method = "GET"
  input.path = ["finance", "salary", username]
  subordinates[input.user][_] == username
}
