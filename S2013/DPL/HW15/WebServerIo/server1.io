
HOST := "localhost"
UIDC := "perl -MPOSIX -E 'say getuid()'"
PORT := 5000 + System runCommand(UIDC) stdout asNumber

# Make a multi-threaded server equivilent to the Ruby server0
# using an actor object to handle each request.
#
# Call the "doWork" block below to get your responses.

counter := 0
values  := list()

doWork := block(
  vv := counter
  counter = counter + 1
  wait(1.0 + Random value)
  values append(vv)
  values)
