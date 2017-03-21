# 120 > OOP_book_scratchpad.rb

module Speak
  def speak(sound)
    puts "#{sound}"
  end
end

class GoodDog
  include Speak
end

class HumanBeing
  include Speak
end

puts "---GoodDog ancestors---"
puts GoodDog.ancestors
puts ''
puts "--HumanBeing ancestors"
puts HumanBeing.ancestors

sparky = GoodDog.new
sparky.speak("Arf!")
bob = HumanBeing.new
bob.speak("Hello!")
  
sparky = GoodDog.new #Sparky is an object - or instance - or both


class GoodDog 
  attr_accessor :name, :height, :weight
  
  def initialize n, h, w
    self.name = n
    self.height = h
    self.weight = w
  end
  
  def change_info n, h, w
    self.name = n
    self.height = h
    self.weight = w
  end
  
  def info
    "#{self.name} weighs #{self.weight} and is #{self.height} tall."
  end
  
  def what_is_self
    self
  end
end

sparky = GoodDog.new "Sparky", "12 inches", "10 lbs"
p sparky.what_is_self

class RobotFriend
  ROBOT_YEARS = 0.001
  
  @@number_of_robots = 0
  attr_accessor :name, :age
  
  def initialize(n, a)
    @@number_of_robots += 1
    self.name = n
    self.age = a * ROBOT_YEARS
    puts "#{name} is your new robot friend!".upcase
  end
  
  def self.total_number_of_robots
    @@number_of_robots
  end
  
  def to_s
    "FREAKY!"
  end
end

puts RobotFriend.total_number_of_robots

martin = RobotFriend.new("martin", 5)
robby = RobotFriend.new("robby", 1)

puts RobotFriend.total_number_of_robots
puts robby.age
puts martin
p martin
p robby.inspect