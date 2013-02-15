#!/usr/bin/ruby

$units = {
  meters:    1.0,
  feet:      0.3048,
}

# Write code that when loaded as a library allows unit values
# and conversions to be written as method calls like this:
#   5.feet.to_s => "5.0 feet"
#   5.9.meters.in_feet.to_s => "19.3569 feet"
#
# Unit conversion rates will be stored in the global '$units'
# hash. Example values are shown above, but users of your library
# (e.g. the tests) can and will add new units to the table.
#
# This will require the use of the metaprogramming techniques
# described in Day 3 of the Ruby chapter. 
