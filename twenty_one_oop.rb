require 'yaml'
require 'pry'
class BlackJackShared
  MESSAGES = YAML.load_file('prompts.yml')

  def initialize
    @prompts = ENV["GENERIC_PROMPT"] ? MESSAGES['generic'] : MESSAGES['voiced']
  end

  def messages(message)
    @prompts[message]
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
    puts format(messages("stay"), name: player.name)
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
    puts format(messages('show'), name: name, hand: hand.join(', '))
    puts "#{messages('total')}: #{total}" if ENV["MATH_IS_HARD"]
  end

  private

  def ace_calc(points)
    ace_count = hand.count("A")
    total_points = ace_count * 11 + points

    if total_points > PLAY_TO
      ace_count.times { total_points -= 10 if total_points > PLAY_TO }
    end

    total_points
  end
end

class Player < Participant
  def choice
    h_or_s = nil

    loop do
      puts messages("h_or_s")
      h_or_s = gets.chomp.upcase
      break(h_or_s) if h_or_s == "H" || h_or_s == "S"

      puts messages('h_or_s_error')
    end
  end
end

class Dealer < Participant
  HIT_UNTIL = 17

  def choice(deck)
    loop do
      if keep_hitting?
        puts messages("dealer_hits")
        sleep(0.3)
        hand << deck.draw
        display_hand
        sleep(0.3)
      else
        puts busted? ? messages("dealer_busts") : messages("dealer_stays")
        sleep(0.3)
        break
      end
    end
  end

  private

  def keep_hitting?
    total < HIT_UNTIL
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
    @cards = NEW_DECK.dup if @cards.values.all?(&:zero?)

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

    if ENV["GENERIC_PROMPT"]
      @player = Player.new("Player")
      @dealer = Dealer.new("Dealer")
    else
      @player = Player.new("PLAYER")
      @dealer = Dealer.new("DEALER")
    end

    @game_count = 1
  end

  def start
    display_welcome_message

    loop do
      deal_cards
      show_initial_cards
      player_turn
      dealer_turn unless @player.busted?
      result
      break unless play_again?
      reset
    end

    display_goodbye_message
  end

  private

  def display_welcome_message
    puts messages('welcome_message').center(80)
  end

  def deal_cards
    2.times { @player.hand << @deck.draw }
    2.times { @dealer.hand << @deck.draw }
  end

  def show_initial_cards
    puts format(messages('initial_player_hand'), card1: @player.hand[0],
                                                 card2: @player.hand[1])
    puts mental_math if ENV["MATH_IS_HARD"]
    puts format(messages('initial_dealer_hand'), card: dealer.hand[0])
  end

  def mental_math
    "#{messages('initial_total')}: #{player.total}"
  end

  def display_goodbye_message
    puts messages("goodbye")
  end

  def player_turn
    turn_messages

    loop do
      break if @player.winning_score?
      choice = @player.choice
      if choice == "S"
        puts @stay_message
        break
      end

      @player.hand << @deck.draw
      @player.display_hand
      turn_messages
      break if @player.busted? || @player.winning_score?
    end

    puts @win_score_message if @player.winning_score?
    sleep(0.3)
  end

  def turn_messages
    @stay_message = format(messages('player_stays'), total: player.total)
    @win_score_message = format(messages('winning_score'), total: player.total)
  end

  def dealer_turn
    @dealer.display_hand
    @dealer.choice(@deck)
  end

  def result
    result = calculate_result
    display_result(result)
  end

  def calculate_result
    case
    when player.busted? then :player_bust
    when dealer.busted? then :dealer_bust
    when player.total == dealer.total then :tie
    when player.total > dealer.total then :player
    else
      :dealer
    end
  end

  def display_result(result)
    sleep(0.5)
    result_messages

    puts case result
         when :player_bust then @p_bust_message
         when :dealer_bust then@d_bust_message
         when :tie then messages('tie')
         when :player then @p_win_message
         when :dealer
           @d_win_message
         end
  end

  def result_messages
    p_total = player.total
    d_total = dealer.total

    @p_bust_message = format(messages('p_bust'), total: p_total)
    @d_bust_message = format(messages('d_bust'), total: d_total)
    @d_win_message = format(messages('d_win'), p_total: player.total,
                                               d_total: dealer.total)
    @p_win_message = format(messages('p_win'), p_total: p_total,
                                               d_total: d_total)
  end

  def play_again?
    answer = ""

    loop do
      puts messages('play_again')
      answer = gets.chomp.upcase
      break if %w[Y N].include? answer
      puts messages('play_again_error')
    end

    answer == 'Y'
  end

  def reset
    @deck = Deck.new
    @player.hand = []
    @dealer.hand = []
    @game_count += 1
    clear_screen
    puts format(messages('new_game'), game_count: @game_count)
  end

  def clear_screen
    system('clear') || system('cls')
  end
end

game = BlackJackLite.new
game.start
