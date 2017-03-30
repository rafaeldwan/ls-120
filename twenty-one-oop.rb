class Player < Participant
  def initialize
    # what would the "data" or "states" of a Player object entail?
  end
  
  def choice
  end
end

class Dealer < Participant
  def initialize
    # what would the "data" or "states" of a player object entail?
    # maybe cards? a name?
  end
  
  def choice
  end
end

class Participant
  include Hand
  
  def hit
  end
  
  def stay
  end
  
  def busted?
  end
  
  def total
  end
end

module Hand
  
end

class Deck
  def initialize
    # obviously, we need some data structure to keep track of cards
    # array, hash, something else?
  end
  
  def deal
    # does the dealer or the deck deal?
  end
end

class Card
  def initialize
    # what are the "states" of a card  
  end
end

class Game
  
  def initialize
    @deck = Deck.new
    @player = Player.new
    @dealer = Dealer.new
  end
  
  def start
    display_welcome_message
    deal_cards
    show_initial_cards
    player_turn
    dealer_turn
    show_result
    display_goodbye_message
  end
  
  def display_welcome_message
    puts "HELLO. IT IS 21."
  end
  
  def deal_cards
    2.times { @player.hand << deck.draw }
    2.times { @dealer.hand << deck.draw }
  end
  
  def show_initial_cards
    puts "IN YOUR HAND IS #{@player.hand}." # requires hand.to_s
    puts "THE DEALER IN TURN SHOWS #{@dealer.hand[0]}" # requires hand.[]
  
  def display_goodbye_message
    puts "AND SO IT ENDS."
  end
  
  def player_turn
    @player.choice
  end
  
  def dealer_turn
    @dealer.choice
  end
  
  
  
end