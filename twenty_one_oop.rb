require 'erb'
require 'pry'
require_relative "prompts"

class BlackJackShared
  def initialize
    @prompt = ENV["GENERIC_PROMPT"] ? @generic_prompt : Prompts.voiced_prompt
  end
end


class Participant < BlackJackShared
  PLAY_TO = 21

  attr_accessor :hand
  attr_reader :name

  def initialize(name)
    super()
    @hand = []
    @name = name
    @play_to = PLAY_TO
  end

  def stay
    puts @prompt[:stay]
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
    puts @prompt[:show]
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
      puts @prompt[:h_or_s]
      h_or_s = gets.chomp.upcase
      break(h_or_s) if h_or_s == "H" || h_or_s == "S"
      puts @prompt[:h_or_s_error]
    end
  end
end

class Dealer < Participant
  HIT_UNTIL = 17

  def choice(deck, player_total)
    loop do
      if keep_hitting?(player_total)
        puts @prompt[:dealer_hits]
        sleep(0.3)
        hand << deck.draw
        display_hand
        sleep(0.3)
      else
        busted? ? (puts @prompt[:dealer_hits]) : (puts @prompt[:dealer_stays])
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

class BlackJackLite < BlackJackShared
  attr_reader :player, :dealer

  def initialize
    super
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
    puts @prompt[:welcome_message]
  end

  def deal_cards
    2.times { @player.hand << @deck.draw }
    2.times { @dealer.hand << @deck.draw }
  end

  def show_initial_cards
    # binding.pry
    puts @prompt[:initial_player_hand].result binding
    puts @prompt[:initial_dealer_hand].result binding
  end

  def display_goodbye_message
    puts @prompt[:goodbye]
  end

  def player_turn
    loop do
      choice = @player.choice
      if choice == "S"
        puts @prompt[:player_stays]
        break
      end
      @player.hand << @deck.draw
      @player.display_hand
      break if @player.busted? || @player.winning_score?
    end

    if @player.winning_score?
      puts @prompt[:winning_score]
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
    when :player_bust then puts @prompt[:outcome_p_bust]
    when :dealer_bust then puts @prompt[:outcome_d_bust]
    when :tie then puts @prompt[:outcome_tie]
    when :dealer
      puts @prompt[:outcome_dealer_win]
    end
  end

  def play_again?
    answer = ""
    loop do
      puts @prompt[:play_again]
      answer = gets.chomp.upcase
      break if %w[Y N].include? answer
      puts @prompt[:play_again_error]
    end
    answer == 'Y'
  end

  def reset
    @deck = Deck.new
    @player.hand = []
    @dealer.hand = []
    @game_count += 1
    clear_screen
    puts @prompt[:new_game]
  end

  def clear_screen
    system('clear') || system('cls')
  end
end

game = BlackJackLite.new
game.start
