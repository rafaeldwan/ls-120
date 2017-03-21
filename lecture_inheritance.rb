class Pet
  def run 
    "running"
  end
  
  def jump
    "jumping"
  end
end

class Cat < Pet
  def speak
    "meowers"
  end
end

class Dog < Pet
  def swim
    "swimming"
  end
  
  def fetch
    "fetching!"
  end
  
  def speak
    "arf"
  end
end

class Bulldog < Dog
  
  def swim
    "can't swim I'm a bulldog!"
  end
end

teddy = Dog.new
puts teddy.speak
puts teddy.swim

monty = Bulldog.new
puts monty.speak
puts monty.swim

pete = Pet.new
kitty = Cat.new
dave = Dog.new
bud = Bulldog.new

pete.run                # => "running!"
pete.speak              # => NoMethodError

kitty.run               # => "running!"
kitty.speak             # => "meow!"
kitty.fetch             # => NoMethodError

dave.speak              # => "bark!"

bud.run                 # => "running!"
bud.swim                # => "can't swim!"

  #     Pet
  #     |
  #     ---
  #     | |
  #   Dog Cat
  #   |
  # Bulldog