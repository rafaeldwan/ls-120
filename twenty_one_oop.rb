class Participant
  PLAY_TO = 21

  attr_accessor :hand
  attr_reader :name

  def initialize(name)
    @hand = []
    @name = name.upcase
    @play_to = PLAY_TO
  end

  def stay
    puts "#{name} STAYS."
  end

  def total
    points = 0
    hand.each do |card|
      if card.to_i != 0 # check if integer
        points += card.to_i
      elsif %w[J K Q].include?(card)
        points += 10
      end
    end
    points = ace_calc(points) if hand.include?("A")
    points
  end

  def busted?
    total > @play_to
  end

  def winning_score?
    total == @play_to
  end

  def display_hand
    puts "#{name} SHOWS #{hand.join(', ')}"
  end

  private

  def ace_calc(points)
    hand.each do |card|
      if card == "A"
        points += (points <= @play_to - 11 ? 11 : 1)
      end
    end
    points
  end
end

class Player < Participant
  def choice
    h_or_s = nil
    loop do
      puts "YOU MUST CHOOSE [H]IT or [S]TAY"
      h_or_s = gets.chomp.upcase
      break(h_or_s) if h_or_s == "H" || h_or_s == "S"
      prompt "THAT IS NOT A VALID INPUT. ERROR. RETRY."
    end
  end
end

class Dealer < Participant
  HIT_UNTIL = 17

  def choice(deck, player_total)
    loop do
      if keep_hitting?(player_total)
        puts "DEALER MUST HIT"
        sleep(0.3)
        hand << deck.draw
        display_hand
        sleep(0.3)
      else
        busted? ? (puts "DEALER BUSTS") : (puts "DEALER STAYS")
        sleep(0.3)
        break
      end
    end
  end

  private

  def keep_hitting?(player_total)
    total < HIT_UNTIL || (total <= player_total && total < PLAY_TO)
  end
end

class Deck
  NEW_DECK = { "2" => 4, "3" => 4, "4" => 4, "5" => 4, "6" => 4,
               "7" => 4, "8" => 4, "9" => 4, "10" => 4, "J" => 4, "Q" => 4,
               "K" => 4, "A" => 4 }

  FACE_CARDS = ["J", "Q", "K", "A"]

  attr_accessor :cards

  def initialize
    @cards = NEW_DECK.dup
  end

  def draw
    card = nil
    @cards = NEW_DECK.dup if @cards.values.all? == 0
    loop do
      card = rand(2..14)
      card = card <= 10 ? card.to_s : FACE_CARDS[card - 11]
      break unless @cards[card] == 0
    end
    @cards[card] -= 1
    card
  end
end

class BlackJackLite
  attr_reader :player, :dealer

  def initialize
    @deck = Deck.new
    @player = Player.new("Player")
    @dealer = Dealer.new("Dealer")
    @game_count = 1
  end

  def start
    display_welcome_message
    loop do
      deal_cards
      show_initial_cards
      player_turn
      dealer_turn unless @player.busted? || @player.winning_score?
      result
      break unless play_again?
      reset
    end
    display_goodbye_message
  end

  private

  def display_welcome_message
    puts "HELLO. IT IS 21."
  end

  def deal_cards
    2.times { @player.hand << @deck.draw }
    2.times { @dealer.hand << @deck.draw }
  end

  def show_initial_cards
    puts "IN YOUR HAND IS #{@player.hand[0]} AND #{@player.hand[1]}."
    puts "THE DEALER IN TURN SHOWS #{@dealer.hand[0]}"
  end

  def display_goodbye_message
    puts "AND SO IT ENDS."
  end

  def player_turn
    loop do
      choice = @player.choice
      if choice == "S"
        puts "YOU STAY AT #{player.total}"
        break
      end
      @player.hand << @deck.draw
      @player.display_hand
      break if @player.busted? || @player.winning_score?
    end

    if @player.winning_score?
      puts "#{player.total}. DEALER CANNOT BEAT THAT AND AT BEST CAN TIE."
    end
    sleep(0.3)
  end

  def dealer_turn
    @dealer.display_hand
    @dealer.choice(@deck, @player.total)
  end

  def result
    result = calculate_result
    display_result(result)
  end

  def calculate_result
    if player.busted? then :player_bust
    elsif dealer.busted? then :dealer_bust
    elsif player.total == dealer.total then :tie
    elsif player.total > dealer.total then :player
    else :dealer
    end
  end

  def display_result(result)
    sleep(0.5)
    case result
    when :player_bust then puts "YOU BUSTED WITH #{player.total}. IT IS COMMON. YOU LOSE"
    when :dealer_bust then puts "DEALER BUSTED WITH #{dealer.total}. YOU HAVE WON"
    when :tie then puts "UNCOMMON BUT NOT REMARKABLE: A TIE"
    when :dealer
      print "AT #{player.total} TO #{dealer.total} YOU WERE BEATEN BY THE "
      puts "DEALER IN ACCORDANCE WITH THE RULES"
    end
  end

  def play_again?
    answer = ""
    loop do
      puts "ANOTHER GAME IS POSSIBLE. INPUT YOUR CHOICE: Y OR N."
      answer = gets.chomp.upcase
      break if %w[Y N].include? answer
      puts "INVALID. Y OR N. ERROR. RETRY."
    end
    answer == 'Y'
  end

  def reset
    @deck = Deck.new
    @player.hand = []
    @dealer.hand = []
    @game_count += 1
    clear_screen
    puts "BEGINNING GAME #{@game_count}."
  end

  def clear_screen
    system('clear') || system('cls')
  end
end

game = BlackJackLite.new
game.start
