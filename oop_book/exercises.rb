
module LookAtThatThing
  def look_at_that_thing(there)
    puts "Look at #{there}!"
  end
end

class Thing
  include LookAtThatThing
  attr_accessor :those, :them, :the_other
  
  def self.what_am_i
    "What is anything?".upcase
  end
  
  
  def initialize(this, that, the_fear)
    @those = this
    @them = that
    @the_other = the_fear
    puts "OH MY GOD IT HAS BEGUN"
  end
  
  # def those
  #   @those
  # end
  
  # def those=(these)
  #   @those = these
  # end
  
  # refactored by using attr_accessor above
  
  def whizbang
    "#{them} is pretty whizbang!"
  end
  
  def change_up(this, that, the_fear)
    self.those = this
    self.them = that
    self.the_other = the_fear
    puts "EVERYTHING IS CHANGING"
  end
  
  def info
    "those = #{self.those}, them = #{them}, the_other = #{@the_other}."
  end
  
end



my_first_object = Thing.new("here", "there", "Jews")
my_first_object.look_at_that_thing("what")
puts my_first_object.whizbang
# puts my_first_object.get_those refactored:
puts my_first_object.those
# my_first_object.set_those = "things" refatored
my_first_object.those = "things"
puts my_first_object.those

puts my_first_object.info

my_first_object.change_up("who", "when", "Muslims")

puts my_first_object.info

 # 
 
 # Exercises
 
 # input: new object
  #   year
  #   color
  #   model
  #   && speed = 0
  
  # rules: methods for speed up
  #                   brake
  #                   turn off car

class Vehicle
  attr_accessor :color
  attr_reader :year
  @@vehicle_count = 0
  
  def initialize(year, color, model)
    @year = year
    @color = color
    @model = model
    @speed = 0
    @@vehicle_count += 1
  end
  
  def self.vcount
    @@vehicle_count
  end
  
  def speed_up(speedy_num)
    @speed += speedy_num
    @speed
  end
  
  def brake
    @speed -= 10
    @speed
  end
  
  def spraypaint
    puts "What color bud?"
    self.color = gets.chomp
    puts "You spraypaint the car #{color}."
  end
  
    def to_s
    puts "Model: #{@model}\nYear: #{self.year}\nColor: #{self.color}\nCurrent Speed: #{@speed}"
  end
  
  def mileage_calc
    puts "HOW MANY MILES DID IT GO?"
    miles = gets.chomp.to_i
    puts "HOW MUCH OF THE GAS GALLONS DID IT TAKE TO GO #{miles} MILES?"
    fuel = gets.chomp.to_f
    @mileage = miles / fuel
    puts "YOUR #{@model.upcase} GETS #{@mileage.round(2)} MILES PER GALLON. FYI."
  end
  
  private
  
  def age
    Time.new.year - self.year
  end
  
end

module Freight
  def haul_shit
    "Let's haul some shit!"
  end
end

class MyCar < Vehicle
  VIN_PREFIX = "MYCAR-"
  
  def off_with_you
    if speed > 0 
      puts "you cannot turn off the car while it is moving, you wacko".upcase
    else
      "the engine quiets. the car is at rest".upcase
    end
  end
end

class MyTruck < Vehicle
  include Freight
  VIN_PREFIX = "MYTRUCK-"
  
end

chipper = MyCar.new("1898", "Black", "Model X")
big_bertha = MyTruck.new("1434", "Flames", "Volvo")
p chipper.color
chipper.color = "Mauve"
p chipper.color
#chipper.spraypaint
p chipper.color
p Thing.what_am_i
#chipper.mileage_calc
chipper.to_s
puts chipper
puts big_bertha.haul_shit
puts Vehicle.vcount
# p Vehicle.ancestors
# p MyCar.ancestors
# p MyTruck.ancestors
# p big_bertha.age

class Student
  attr_accessor :name
  
  def initialize(n, g)
    name = n
    @grade = g
  end
  
  def better_grade_than?(other)
    grade > other.grade
  end
  
  protected
  
  def grade
    @grade
  end
end
  
joe = Student.new("Joe", 90)
bob = Student.new("Bob", 80)
  
# bob.grade

puts "Well done!" if joe.better_grade_than?(bob)