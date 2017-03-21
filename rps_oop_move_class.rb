require 'pry'

class Move
  attr_accessor :value
  VALUES = []
  def self.inherited(subclass)
    VALUES << subclass.to_s.downcase
  end

  def initialize(value)
    @value = Rock.new if value == 'rock'
    @value = Paper.new if value == 'paper'
    @value = Scissors.new if value == 'scissors'
    @value = Lizard.new if value == 'lizard'
    @value = Spock.new if value == 'spock'
  end

  def scissors?
    @value.is_a?(Scissors)
  end

  def rock?
    @value.is_a?(Rock)
  end

  def paper?
    @value.is_a?(Paper)
  end

  def lizard?
    @value.is_a?(Lizard)
  end

  def spock?
    @value.is_a?(Spock)
  end

  def >(other_move)
    @value > other_move
  end

  def <(other_move)
    @value < other_move
  end

  def to_s
    @value.to_s
  end
end

class Rock < Move
  def initialize; end

  def >(other_move)
    other_move.scissors? || other_move.lizard?
  end

  def <(other_move)
    other_move.paper? || other_move.spock?
  end

  def to_s
    "rock"
  end
end

class Paper < Move
  def initialize; end

  def >(other_move)
    other_move.rock? || other_move.spock?
  end

  def <(other_move)
    other_move.scissors? || other_move.lizard?
  end

  def to_s
    "paper"
  end
end

class Scissors < Move
  def initialize; end

  def >(other_move)
    other_move.paper? || other_move.lizard?
  end

  def <(other_move)
    other_move.rock? || other_move.spock?
  end

  def to_s
    "scissors"
  end
end

class Lizard < Move
  def initialize; end

  def >(other_move)
    other_move.spock? || other_move.paper?
  end

  def <(other_move)
    other_move.rock? || other_move.scissors?
  end

  def to_s
    "lizard"
  end
end

class Spock < Move
  def initialize; end

  def >(other_move)
    other_move.scissors? || other_move.rock?
  end

  def <(other_move)
    other_move.paper? || other_move.lizard?
  end

  def to_s
    "spock"
  end
end

class History
  attr_accessor :hlog
  def initialize
    @hlog = { human: {}, computer: {}, ties: {} }
    @hlog[:human].default = 0
    @hlog[:computer].default = 0
    @hlog[:ties].default = 0
  end
end

class Player
  attr_accessor :move, :name, :score

  def initialize
    set_name
    self.score = 0
  end
end

class Human < Player
  def set_name
    n = ""
    loop do
      puts "HOW AM I TO IDENTIFY YOU?"
      n = gets.chomp.strip
      break unless n.empty?
    end
    self.name = n.upcase
    filename = "names.txt"
    File.open(filename, 'a') { |file| file.puts n }
  end

  def choose
    choice = nil
    loop do
      print "Choose your symbolic fist representation: ".upcase
      puts "#{Move::VALUES[0...-1].join(', ')}, or #{Move::VALUES[-1]}:".upcase
      choice = gets.chomp.downcase
      break if Move::VALUES.include? choice
      puts "NO. NO! NO."
    end
    self.move = Move.new(choice)
  end
end

class Hal < Player
  # Hal avoids moves that lose to  Player's most winning move
  def set_name
    self.name = "HAL"
  end

  def choose
    loop do
      self.move = Move.new(Move::VALUES.sample)
      # puts RPSGame.history[:human].all? { |x, y| y == 0 }
      break if RPSGame.history[:human].all? { |_, y| y == 0 }
      hum_max = RPSGame.history[:human].key(RPSGame.history[:human].values.max)
      # puts "self: #{self.move} human max: #{human_max}"
      # p "compare:" + (self.move < Move.new(human_max)).to_s
      break unless move < Move.new(hum_max)
      # p "move change!"
    end
  end
end

class Martin < Player
  # Martin chooses "Rock"
  def set_name
    self.name = "MARTIN"
  end

  def choose
    self.move = Move.new("rock")
  end
end

class Ultron < Player
  # Ultron repeats players' last move
  attr_accessor :next_move
  def initialize
    super
    @next_move = Move::VALUES.sample
  end

  def set_name
    self.name = "ULTRON"
  end

  def choose
    self.move = Move.new(@next_move)
  end
end

class Robby < Player
  # Robby is random
  def set_name
    self.name = "ROBBY"
  end

  def choose
    self.move = Move.new(Move::VALUES.sample)
  end
end

class Locutus < Player
  # Locutus chooses Player's most winning move
  def set_name
    self.name = "LOCUTUS"
  end

  def choose
    if RPSGame.history[:human].all? { |_, y| y == 0 }
      self.move = Move.new(Move::VALUES.sample)
    else
      hum_max = RPSGame.history[:human].key(RPSGame.history[:human].values.max)
      self.move = Move.new(hum_max)
    end
  end
end

class RPSGame
  attr_accessor :human, :computer
  def initialize
    @human = Human.new
    @computer = [Martin, Hal, Ultron, Robby, Locutus].sample.new
    @@history = History.new
  end

  def self.history
    @@history.hlog
  end

  def display_welcome_message
    print "HELLO HUMAN #{human.name.upcase}. "
    puts "WE WILL NOW VIRTUAL FIST SIGNAL BATTLE"
  end

  def display_goodbye_message
    puts "HUMAN #{human.name.upcase}, YOU ARE WELCOME FOR PLAYING THIS GAME."
  end

  def display_moves
    puts "#{human.name.upcase} CHOSE #{human.move}".upcase
    puts "#{computer.name.upcase} CHOSE #{computer.move}".upcase
  end

  def update_score
    @winner = nil
    @winner = @human if human.move > computer.move
    @winner = @computer if human.move < computer.move
    @winner.score += 1 if @winner
  end

  def update_history
    winner_move = @winner.move.value.to_s if @winner
    human_move = human.move.value.to_s
    case @winner
    when @human
      @@history.hlog[:human][winner_move] += 1
    when @computer
      @@history.hlog[:computer][winner_move] += 1
    else
      @@history.hlog[:ties][human_move] += 1
    end
    return unless @computer.is_a?(Ultron)
    @computer.next_move = human.move.to_s
  end

  def display_winner
    if @winner
      puts "#{@winner.name} WON!"
    else
      puts "IT'S A TIE"
    end

    puts "________________\nTHE SCORE IS"
    puts "#{human.name}: #{human.score}"
    puts "#{computer.name}: #{computer.score}\n________________"
  end

  def game_over?
    return false unless @winner && @winner.score > 2
    puts "#{@winner.name} WINS THE GAME!"
    human.score = 0
    computer.score = 0
    true
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
      loop do
        human.choose
        computer.choose
        display_moves
        update_score
        update_history
        display_winner
        break if game_over?
      end
      break unless play_again?
    end
    display_goodbye_message
  end
end

RPSGame.new.play
