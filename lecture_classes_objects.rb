# Courses > 120 > Lesson 2 > Lecture: Classes and Objects

require 'pry'

class Person
  attr_accessor :first_name, :last_name
  
  def initialize(name)
    parse_full_name(name)
  end

  def name
    "#{@first_name} #{@last_name}".strip
  end
  
  def name=(string)
    parse_full_name(string)
  end
  
  def to_s
    name
  end
  
  private
  
  def parse_full_name(name)
    parts = name.split
    @name = name
    @last_name = parts.size > 1 ? parts[-1] : ''
    @first_name = parts[0]
  end
end

# bob = Person.new('bob')
# bob.name                  # => 'bob'
# bob.name = 'Robert'
# bob.name

# bob = Person.new('Robert Johnson')
# p bob.name                  # => 'Robert Johnson'
# p bob.first_name            # => 'Robert'
# p bob.last_name             # => ''
# p bob.last_name = 'Smith'
# p bob.name            

bob = Person.new('Robert')
bob.name                  # => 'Robert'
bob.first_name            # => 'Robert'
bob.last_name             # => ''
bob.last_name = 'Smith'
bob.name                  # => 'Robert Smith'

bob.name = "John Adams"
bob.first_name            # => 'John'
bob.last_name             # => 'Adams'
  
bob = Person.new('Robert Smith')
rob = Person.new('Robert Smith')

p bob.name == rob.name

p "the person's name is #{bob.name}"
p "the person's name is #{bob}"