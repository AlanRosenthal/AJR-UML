
# Solve the T9 Spelling problem.
#
# The name of the input file will be passed as ARGV[1]
#
# See the Io Guide for how to access command line arguments
# and read files:
#   http://iolanguage.org/scm/io/docs/IoGuide.html


"t9_spelling"


T9 := Object clone

T9 file := System args at(1)
T9 read := method(
    f := File with(file) openForReading
    T9 lines := f readLine asNumber
    T9 data := list()
    f foreachLine(i, v, data append(v))
)
T9 processall := method(
    data = data map(x,process(x))
    a := Sequence clone
    for (i,0,lines-1,
        a = "Case ##{i+1}: #{data at(i)}" asMutable interpolate
        a println
    )
)
T9 process := method(s,
    #find the spot in the list, and replace it with the approate number of digits, eg c is replaced with 222.
    convertlist := list(" ","","abc","def","ghi","jkl","mno","pqrs","tuv","wxyz")
    l := list()
    a := Sequence clone
    s asList foreach(i,c,
        a = "" asMutable
        convertlist foreach(ii,cc,
            spotinlist := cc findSeq(c)
            if (spotinlist,
                for(j,0,spotinlist,a = a appendSeq(ii))
            )
        )
        l append(a)
    )
    #checked the list and sees if anything next to each other are the same, eg 2 vs 222, if they are, adds a pause
    result := List clone
    if (l size < 2,
        l join,
        for(i,0,l size-2,
            if (l at(i) at(0) == l at(i+1) at(0),
                result append(l at(i)) append(" "),result append(l at(i)))
        )
        result append(l at(i+1)) join
    )
)
T9 read
T9 processall