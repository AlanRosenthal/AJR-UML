
# Create a prototype "Examiner" that prints the following information
# about any message you send its clones:
#   Io> Inspector := Examiner clone
#   Io> steve := Inspector clone
#   Io> steve someMessage(a + b, list(1,2,3))
#   I am Inspector_0x29135c0.
#   My prototype is Inspector_0x27b5160, so I'm an Inspector.
#   I just got someMessage, with 1 argument(s).
#   The message came from Object_0x25db720, of type Object.
#   The arguments were:
#     0: a +(b)
#     1: list(1, 2, 3) 
#
# Pull the object names (like "Inspector_0x29135c0" out of the
# stringification (asString value) of the object.




Examiner := Object clone
Examiner forward := method(
    self println
    self proto println
    call sender println
    #call message name println
    #call message arguments println
    #   I am Inspector_0x29135c0.
    #   My prototype is Inspector_0x27b5160, so I'm an Inspector.
    #   I just got someMessage, with 1 argument(s).
    #   The message came from Object_0x25db720, of type Object.
    #   The arguments were:
    #     0: a +(b)
    #     1: list(1, 2, 3) 
)

Inspghjector := Examiner clone
steve := Inspghjector clone
steve someMesssage(a + b, list(1,2,3))





# Create a method "switch" that takes an integer n as its first argument
# and and any number of addiontal arguments. Return the result of
# running whatever code is passed as the nth argument after the integer
# (counting from 0), and don't evaluate any of the other arguments.
#
# Example:
#  Io> switch(2, "hello" println, 3, 4, 5)
#  ==> 4





# Overload operators and methods such that Map literals can
# be specified like this:
# 
#   score := map("Patriots" :: 4, "Giants" :: 7, "Cowboys" :: 9)
#
# Make maps stringify to that constructor format, like lists.
# (List keys in alphabetical order)
#
#   Io> map("One" :: 1, "Two" :: 2)
#   map(One :: 1, Two :: 2)
#
# If one of the arguments to "map" is not a pair, throw an
# exception with the message "Bad pair in map"
#
# And values can be accessed in Map objects like this:
#
#   Io> score["Patriots"]
#   ==> 4





# Implement list comprehensions. Here are some examples:
#
#   Io> comp(x + 1, x <- list(1, 2))
#   ==> list(2, 3)
#   Io> comp(x + y, x <- list(1,2,3), y <- list(1,2,3), x != y)
#   ==> list(3, 4, 3, 5, 4, 5)





#1;
