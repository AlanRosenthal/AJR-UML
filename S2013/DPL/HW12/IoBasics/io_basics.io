#!/usr/bin/env io
# Reference the 'Range' addon to add to() method to numbers
Range

# fibR(n) = the nth Fibonacci number
#  solve this recursively

fibR := method(n, if (n == 1,1,if(n == 2,1,fibR(n-1)+fibR(n-2))))

fibI := method(n,
    fib1 := 1
    fib2 := 1
    for(i,3,n,
        temp := fib2 + fib1
        fib1 := fib2
        fib2 := temp)
    fib2)

# Square a list of numbers using "map" with
# a single argument.
#
# See the Io Guide for API docs:
#   http://iolanguage.org/scm/io/docs/IoGuide.html#Primitives-List

squareList1 := method(n, n map(**2))

# Square a list using "map" with two arguments.

squareList2 := method(n, n map(n,n*n))

# Add a foldl(fn, acc) method to list, where the fn argument
# will take a block.

List foldl := method(fn, acc,
    if (self isEmpty,acc,
        self rest foldl(fn,fn call(acc,self first))))

# Now use your foldl to implement a version of map that takes
# a block (as a map1 method on List).

List map1 := method(fn,self foldl(block(acc,n,acc append(fn call(n))),list()))

# Create Duck and Dog objects such that when they're used
# as prototypes:
#   myDuck speak => "Quack!"
#   myDog  speak => "Woof!"

Duck := Object clone
Duck speak := "Quack!"
Dog := Object clone
Dog speak :=  "Woof!"

# Create a Matrix prototype that represents a 2D array.
# Indexes should start at 0.
# 
#  The "dim(width, height)" method should allocate
#  a Matrix full of zeros.
#
#  The "get(y, x)" method should fetch a value.
# 
#  The "set(y, x, v)" method should set a value.
#
#  The "mapIndexes(block)" method should, for each element
#  v in the matrix, call the block with the values (x, y, v)
#  and store the result in the correct slot in a new matrix
#  of the same size.
#
#  The "transpose" method called on the matrix "aa" should 
#  return a Matrix "bb" such that "aa get(x, y) == bb get(y, x)". 
#
#  The "asString" method should render the matrix like this:
#
#  Io> aa := Matrix dim(3, 3)
#  Io> aa set(0, 1, 7)
#  Io> aa set(2, 0, 5)
#  Io> aa asString
#  ==> Matrix(3, 3):
#   0 7 0
#   0 0 0
#   5 0 0
#
#  Note that Io can do Ruby-style string interpolation like this:
#  Io> aa := 5
#  Io> "aa + 3 = #{aa + 3}" interpolate
#  ==> aa + 3 = 8

Matrix := Object clone

Matrix dim := method(height, width,
    line := list()
    for(i,1,width,line append(0))
    matrix := list()
    for(j,1,height,matrix append(line))
    matrix)

List set := method(y,x,v,
    line := self at(y)
    newline := list()
    for(i,0,line size -1,
        if (i == x,newline append(v),newline append(line at(i))))
    atPut(y,newline))
    
List get := method(y,x,
    self at(y) at(x))

List mapIndexes := method(fn,
    height := self size
    width := self at(0) size
    A := Matrix dim(height,width)
    for(i,0,height-1,
        for(j,0,width-1,
            A := A set(i,j,fn call(i,j,self get(i,j))))))
            
List transpose := method(
    height := self size
    width := self at(0) size
    A := Matrix dim(width,height)
    for(i,0,height-1,
        for(j,0,width-1,
            A := A set(j,i,self get(i,j)))))
            
List asString2 := method(
    height := self size
    width := self at(0) size
    a := "Matrix (#{height}, #{width})\n" interpolate asMutable
    for(i,0,height - 1,
        for(j,0,width -1,
            b := " #{self get(i,j)}" interpolate asMutable
            a appendSeq(b))
            a appendSeq("\n"))
    a interpolate)



# This makes doFile less annoying in the REPL.
"io_basics.io"
