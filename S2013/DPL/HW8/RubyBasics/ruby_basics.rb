
# fib(n) = requthe nth Fibonacci number
# Any solution is fine.

def fib(n)
    return 1 if n == 1
    return 1 if n == 2
    fib = 1
    fib1 = 1
    i = 2
    while i < n
        temp = fib          #put fib into temp 
        fib = fib + fib1    #fib = fib + fib1
        fib1 = temp         #fib1 = temp (old value of fip)
        i = i + 1
    end
    fib
end

# Square a list of numbers.
# Use "map" and a block.

def square_list(xs)
    xs.map{|x| x**2}
end

# Implement map using inject and a block.
#  - In my_map1, use 'yield'
#  - In my_map2, accept a Proc object in 'fn'
#
# http://www.ruby-doc.org/core-1.9.3/Proc.html

def my_map1(xs)
    xs.inject([]) { |acc,x| acc << yield(x) }
end

def my_map2(xs, &fn)
    the_fn = Proc.new(&fn)
    xs.inject([]) { |acc,x| acc << the_fn.call(x) }
end

# Implement a Duck class and a Dog class, such that
#   my_duck.speak => "Quack!"
#   my_dog.speak  => "Woof!"

class Duck
    def speak
        "Quack!"
    end
end
class Dog
    def speak
        "Woof!"
    end
end


# Use a regular expression substitution to replace all
# instances of the string "banana" with the string "apple".
# Also replace "ba", "bana", "banana", "bananana", etc.

def unbanana(s)
  s.sub(/banananana/,'apple').sub(/bananana/,'apple').sub(/banana/,'apple').sub(/bana/,'apple').sub(/ba/,'apple')
end

# Modify the Tree class from the book (provided in tree.rb)
# to optionally accept a nested structure of hashes to construct
# a complete tree.

class Tree
  attr_accessor :children, :node_name

  def initialize(name, children=[])
    @children  = children
    @node_name = name
  end

  def visit_all(&block)
    visit &block
    children.each {|c| c.visit_all &block }
  end

  def visit(&block)
    block.call self
  end
end

