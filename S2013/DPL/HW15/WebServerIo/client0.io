
HOST := "localhost"
UIDC := "perl -MPOSIX -E 'say getuid()'"
PORT := 5000 + System runCommand(UIDC) stdout asNumber

# TODO:
#
# Write a client that does the following
#
# For each number n in [0..4]:
#
#   Makes an HTTP request from the server with the
#   host and port above (and the path "/").
#
#   Prints "n: response"
#
#   Sample output:
#     0: [0]
#     1: [0, 1]
#     ...
#     4: [0, 1, 2, 3, 4]
#

URL with("http://www.uml.edu/") fetch println
