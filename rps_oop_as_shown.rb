# Rock, Paper, Scissors is a two-player game where each player chooses
# one of three possible moves: rock, paper, or scissors. The chosen moves
# will then be compared to see who wins, according to the following rules:

# - rock beats scissors
# - scissors beats paper
# - paper beats rock

# If the players chose the same move, then it's a tie.

# Nouns: player, move, rules
# Verbs: choose, compared

# Groups verbs and nouns:
# Player
#   choose
# Move
# Rule

# - compare

# game orchestration engine

class Move
  VALUES = %w[rock paper scissors]
  def initialize(value)
    @value = value
  end

  def scissors?
    @value == 'scissors'
  end

  def rock?
    @value == 'rock'
  end

  def paper?
    @value == 'paper'
  end

  def to_s
    @value.upcase
  end

  def >(other_move)
    (rock? && other_move.scissors?) ||
      (paper? && other_move.rock?) ||
      (scissors? && other_move.paper?)
  end

  def <(other_move)
    (rock? && other_move.paper?) ||
      (paper? && other_move.scissors?) ||
      (scissors? && other_move.rock?)
  end
end

class Player
  attr_accessor :move, :name

  def initialize
    set_name
  end
end

class Human < Player
  def set_name
    n = ""
    loop do
      puts "HOW AM I TO IDENTIFY YOU?"
      n = gets.chomp
      break unless n.empty?
    end
    self.name = n.upcase
    filename = "names.txt"
    File.open(filename, 'a') { |file| file.puts n }
  end

  def choose
    choice = nil
    loop do
      puts "Choose your symbolic fist representation: \
rock, paper, or scissors:".upcase
      choice = gets.chomp
      break if Move::VALUES.include? choice
      puts "NO. NO! NO."
    end
    self.move = Move.new(choice)
  end
end

class Computer < Player
  def set_name
    self.name = %w[Martin Hal Ultron Robby Locutus].sample.upcase
  end

  def choose
    self.move = Move.new(Move::VALUES.sample)
  end
end

class RPSGame
  attr_accessor :human, :computer
  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def display_welcome_message
    puts "HELLO HUMAN #{human.name.upcase}. \
WE WILL NOW VIRTUAL FIST SIGNAL BATTLE"
  end

  def display_goodbye_message
    puts "HUMAN #{human.name.upcase}, YOU ARE WELCOME FOR PLAYING THIS GAME."
  end

  def display_moves
    puts "#{human.name.upcase} CHOSE #{human.move}"
    puts "#{computer.name.upcase} CHOSE #{computer.move}"
  end

  def display_winner
    if human.move > computer.move
      puts "#{human.name} WON!"
    elsif human.move < computer.move
      puts "#{computer.name} WON!"
    else
      puts "IT'S A TIE"
    end
  end

  def play_again?
    answer = nil
    loop do
      puts "WANNA AGAIN? (Y/N)"
      answer = gets.chomp.downcase
      break if ['y', 'n'].include? answer
    end
    answer == 'y' ? true : false
  end

  def play
    display_welcome_message
    loop do
      human.choose
      computer.choose
      display_moves
      display_winner
      break unless play_again?
    end
    display_goodbye_message
  end
end

# class Move
#   def initialize
#     # seem like we need something to keep track
#     # of the choice... a move object can be "paper", "rock", or scissor
#   end
# end

# class Rule
#   def initialize
#     # not sure what the "State" of a rule object should be
#   end
# end

# # not sure where "compare" goes yet
# def compare(move1, move2)

# end

RPSGame.new.play
