class Move
  VALUES = %w[rock paper scissors lizard spock]
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
  
  def lizard?
    @value == 'lizard'
  end
  
  def spock?
    @value == 'spock'
  end

  def to_s
    @value.upcase
  end

  def >(other_move)
    (rock? && (other_move.scissors? || other_move.lizard?)) ||
      (paper? && (other_move.rock? || other_move.spock?)) ||
      (scissors? && (other_move.paper? || other_move.lizard?)) ||
      (lizard? && (other_move.spock? || other_move.paper?)) ||
      (spock? && (other_move.scissors? || other_move.rock?))
  end

  def <(other_move)
    (rock? && (other_move.paper? || other_move.spock?)) ||
      (paper? && (other_move.scissors? || other_move.lizard?)) ||
      (scissors? && (other_move.rock? || other_move.spock?)) ||
      (lizard? && (other_move.rock? || other_move.scissors?)) ||
      (spock? && (other_move.paper? || other_move.lizard?))
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
      print "Choose your symbolic fist representation:"
      puts "#{Move::VALUES[0...-1].join(', ')}, or #{Move::VALUES[-1]}:".upcase
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
  
  def update_score
    @winner = nil
    @winner = @human if human.move > computer.move
    @winner = @computer if human.move < computer.move
    @winner.score += 1 if @winner
  end

  def display_winner
    if @winner
      puts "#{@winner.name} WON!"
    else
      puts "IT'S A TIE"
    end
    puts "THE SCORE IS:"
    puts "#{human.name}: #{human.score}"
    puts "#{computer.name}: #{computer.score}"
  end
  
  def game_over?
    if @winner && @winner.score > 2 
        puts "#{@winner.name} WINS THE GAME!"
        human.score = 0
        computer.score = 0
        return true
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
      loop do
        human.choose
        computer.choose
        display_moves
        update_score
        display_winner
        break if game_over?
      end
      break unless play_again?
    end
    display_goodbye_message
  end
end

RPSGame.new.play
