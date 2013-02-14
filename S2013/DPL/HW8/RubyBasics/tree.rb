
# Tree class from "7 Languages in 7 Weeks" p.26

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

#ruby_tree = Tree.new(
#  "Ruby",
#  [Tree.new("Reia"),
#   Tree.new("MacRuby")])
