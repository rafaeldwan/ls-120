module Speed
  def go_fast
    puts "I am a #{self.class} and going super fast!"
  end
end

class Car
  include Speed
  
  def go_slow
    puts "I am safe and driving slow."
  end
end

class Truck
  include Speed
  
  def go_very_slow
    puts "I am a heavy truck and like going very slow."
  end
end

# exploring whether a class has ivars

class Fruit
  def initialize(name)
    name = name
  end
end

class Pizza
  def initialize(name)
    @name = name
  end
end

hot_pizza = Pizza.new("cheese")
orange = Fruit.new("apple")
hot_pizza.instance_variables
orange.instance_variables

# how do we access instance variables?

class Cube
  def initialize(volume)
    @volume = volume
  end
end

big_cube = Cube.new(5000)
big_cube.instance_variable_get("@volume")


class AngryCat
  def initialize(age, name)
    @age = age
    @name = name
  end
  
  def age
    puts @age
  end
  
  def name
    puts @name
  end
  
  def hiss 
    puts "Hissssssss"
  end
end

# Medium 1 > Question 4

class Greeting
  def greet(string)
    puts string
  end
end

class Hello < Greeting
  greet("Hello")
end

class Goodbye < Greeting
  greet("Goodbye")
end


# Medium 1 > Question 5

class KrispyKreme
  def initialize(filling_type, glazing)
    @filling_type = filling_type
    @glazing = glazing
  end
  
  def to_s
    filling = @filling_type ? @filling_type : "Plain"
    if @glazing
      puts "#{filling} with #{@glazing}"
    else
      puts "#{filling}"
    end
  end
end

donut1 = KrispyKreme.new(nil, nil)
donut2 = KrispyKreme.new("Vanilla", nil)
donut3 = KrispyKreme.new(nil, "sugar")
donut4 = KrispyKreme.new(nil, "chocolate sprinkles")
donut5 = KrispyKreme.new("Custard", "icing")

puts donut1
  # => "Plain"

puts donut2
  # => "Vanilla"

puts donut3
 #  => "Plain with sugar"

puts donut4
 # => "Plain with chocolate sprinkles"

puts donut5
 # => "Custard with icing"
 
 # Hard 1 > Question 1
 
 class SecretFile
  # attr_reader :data

  def initialize(secret_data, log)
    @data = secret_data
    @log = log
  end
  
  def data
    @log.create_log_entry
    @data
  end
end


# Hard 1 > Question 2

module Moveable
  
  attr_accessor :speed, :heading
  attr_writer :fuel_capacity, :fuel_efficiency
  def range
    @fuel_capacity * @fuel_efficiency
  end
end

class WheeledVehicle
  include Moveable

  def initialize(tire_array, km_traveled_per_liter, liters_of_fuel_capacity)
    @tires = tire_array
    self.fuel_efficiency = km_traveled_per_liter
    self.fuel_capacity = liters_of_fuel_capacity
  end

  def tire_pressure(tire_index)
    @tires[tire_index]
  end

  def inflate_tire(tire_index, pressure)
    @tires[tire_index] = pressure
  end

  
end

class Auto < WheeledVehicle
  def initialize
    # 4 tires are various tire pressures
    super([30,30,32,32], 50, 25.0)
  end
end

class Motorcycle < WheeledVehicle
  def initialize
    # 2 tires are various tire pressures
    super([20,20], 80, 8.0)
  end
end

class Seacraft
  include Moveable
  
  attr_accessor :hull_count, :propeller_count
  
  def initialize (num_propellers, num_hulls, km_traveled_per_liter, liters_of_fuel_capacity)
    self.fuel_efficiency = km_traveled_per_liter
    self.fuel_capacity = liters_of_fuel_capacity
    self.propeller_count = num_propellers
    self.hull_count = num_hulls
  end
  
  def range
    super + 10
  end
end

class Catamaran < Seacraft
end

class Motorboat < Seacraft
  def initialize (km_traveled_per_liter, liters_of_fuel_capacity)
    super(1, 1, km_traveled_per_liter, liters_of_fuel_capacity)
  end
end