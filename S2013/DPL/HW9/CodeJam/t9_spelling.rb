#!/usr/bin/env ruby

# Please solve the T9 Spelling problem from Google Code Jam:
#   http://code.google.com/codejam/contest/351101/dashboard#s=p2
#
# The test harness expects you to open the file named in ARGV[0]
# yourself rather than accepting the input data on STDIN.


class T9
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
    def addpause(s)
        s = s.gsub(/([abc]){2,}/) {|s| s.split('').join('.')}
        s = s.gsub(/([def]){2,}/) {|s| s.split('').join('.')}
        s = s.gsub(/([ghi]){2,}/) {|s| s.split('').join('.')}
        s = s.gsub(/([jkl]){2,}/) {|s| s.split('').join('.')}
        s = s.gsub(/([mno]){2,}/) {|s| s.split('').join('.')}
        s = s.gsub(/([pqrs]){2,}/) {|s| s.split('').join('.')}
        s = s.gsub(/([tuv]){2,}/) {|s| s.split('').join('.')}
        s = s.gsub(/([wxyz]){2,}/) {|s| s.split('').join('.')}
        s = s.gsub(/([ ]){2,}/) {|s| s.split('').join('.')}
    end
    def converttonum(s)
        s = s.gsub(/a/,'2')
        s = s.gsub(/b/,'22')
        s = s.gsub(/c/,'222')
        s = s.gsub(/d/,'3')
        s = s.gsub(/e/,'33')
        s = s.gsub(/f/,'333')
        s = s.gsub(/g/,'4')
        s = s.gsub(/h/,'44')
        s = s.gsub(/i/,'444')
        s = s.gsub(/j/,'5')
        s = s.gsub(/k/,'55')
        s = s.gsub(/l/,'555')
        s = s.gsub(/m/,'6')
        s = s.gsub(/n/,'66')
        s = s.gsub(/o/,'666')
        s = s.gsub(/p/,'7')
        s = s.gsub(/q/,'77')
        s = s.gsub(/r/,'777')
        s = s.gsub(/s/,'7777')
        s = s.gsub(/t/,'8')
        s = s.gsub(/u/,'88')
        s = s.gsub(/v/,'888')
        s = s.gsub(/w/,'9')
        s = s.gsub(/x/,'99')
        s = s.gsub(/y/,'999')
        s = s.gsub(/z/,'9999')
        s = s.gsub(/ /,'0')        
        s = s.gsub(/\./,' ')
    end
end
a = T9.new
a.read(ARGV[0])
i = 0
while i < a.counter
    puts "Case ##{i+1}: #{a.converttonum(a.addpause(a.cases[i]))}"
    i = i + 1
end