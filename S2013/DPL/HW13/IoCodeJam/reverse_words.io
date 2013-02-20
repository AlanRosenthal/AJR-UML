
# Solve the Reverse Words problem.
#
# The name of the input file will be passed as ARGV[1]
#
# See the Io Guide for how to access command line arguments
# and read files:
#   http://iolanguage.org/scm/io/docs/IoGuide.html


"reverse_words"

ReverseWords := Object clone

ReverseWords file := System args at(1)
ReverseWords read := method(
    f := File with(file) openForReading
    ReverseWords lines := f readLine asNumber
    ReverseWords data := list()
    f foreachLine(i, v, data append(v))
)
ReverseWords processall := method(
    data = data map(x,process(x))
    a := Sequence clone
    for (i,0,lines-1,
        a = "Case ##{i+1}: #{data at(i)}" asMutable interpolate
        a println
    )
)
ReverseWords process := method(s,
    s split(" ") reverse join(" ")
)
ReverseWords read
ReverseWords processall