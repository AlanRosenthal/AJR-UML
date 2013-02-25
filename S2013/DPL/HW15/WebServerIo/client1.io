
HOST := "localhost"
UIDC := "perl -MPOSIX -E 'say getuid()'"
PORT := 5000 + System runCommand(UIDC) stdout asNumber

# TODO:
#
# Write a version of the client using futures that performs
# the HTTP requests concurrently.

