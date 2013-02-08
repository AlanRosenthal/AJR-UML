#!/usr/bin/env ruby

# Please solve the Reverse Words problem from Google Code Jam:
#   http://code.google.com/codejam/contest/351101/dashboard#s=p1
#
# The test harness expects you to open the file named in ARGV[0]
# yourself rather than accepting the input data on STDIN.
#
# The API documentation for the File class is here:
#   http://www.ruby-doc.org/core-1.9.3/File.html
def reverse_words(file)
    a = ReverseWords.new
    a.read(file)
    i = 0
    while i < a.counter
        puts "Case ##{i+1}: #{a.cases[i].split(" ").reverse.join(" ")}"
        i = i + 1
    end
   # puts a.counter
   # print a.cases
end

class ReverseWords
    def read(thefile)
        file = File.new(thefile)
        @counter = file.gets.to_i
        @cases = []
        file.each do |row|
            @cases << row.delete("\n")
        end
    end
    def counter
        @counter
    end
    def cases
        @cases
    end
    def reverseme(words)
        puts words
    end
end
reverse_words(ARGV[0])
