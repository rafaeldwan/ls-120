def clear_screen
  system('clear') || system('cls')
end

class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # columns
                  [[1, 5, 9], [3, 5, 7]] # diagonals

  attr_reader :squares

  def initialize
    @squares = (1..9).each_with_object({}) { |i, hash| hash[i] = Square.new }
    # p @squares
  end

  def []=(key, marker)
    @squares[key].marker = marker
  end

  def [](key)
    @squares[key].marker
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked_key? }
  end

  def draw
    puts <<~HEREDOC
         |     |
     #{@squares[1]}   |  #{@squares[2]}  |  #{@squares[3]}
         |     |
    -----|-----|-----
         |     |
      #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}
         |     |
    -----|-----|-----
         |     |
      #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}
         |     |
    HEREDOC
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def winning_marker
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      return squares.first.marker if three_in_a_row?(squares)
    end
    nil
  end

  def reset
    @squares = (1..9).each_with_object({}) { |i, hash| hash[i] = Square.new }
  end

  private

  def three_in_a_row?(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != 3
    markers.uniq.size == 1
  end
end

class Square
  INITIAL_MARKER = ' '

  attr_accessor :marker

  def marked?
    marker != INITIAL_MARKER
  end

  def initialize(marker=INITIAL_MARKER)
    @marker = marker
  end

  def to_s
    @marker
  end

  def unmarked_key?
    marker == INITIAL_MARKER
  end
end

class Player
  attr_accessor :score, :marker, :name

  def initialize(marker)
    @score = 0
    @marker = marker
  end

  def update_score
    @score += 1
  end
end

class AI
  attr_reader :player, :opponent, :board

  def initialize(difficulty, player, opponent, board)
    @difficulty = difficulty
    @player = player
    @opponent = opponent
    @board = board
  end

  def move
    if @difficulty == 1
      board[random_move] = player.marker
    else
      square = make_winning_move
      square = block_opponent_win if square.nil?
      square = non_winning_decision if square.nil?
      board[square] = player.marker
    end
  end

  private

  def random_move
    board.unmarked_keys.sample
  end

  def make_winning_move
    decision(player.marker, opponent.marker)
  end

  def block_opponent_win
    decision(opponent.marker, player.marker)
  end

  def find_current_line_markers(line)
    line.map { |current_square| board[current_square] }
  end

  def decision(marker, antimarker)
    square = nil
    Board::WINNING_LINES.each do |line|
      current_line_markers = find_current_line_markers(line)
      if current_line_markers.count(marker) == 2
        next if current_line_markers.include?(antimarker)
        line.each do |position|
          if position_clear?(position)
            square = position
            break
          end
        end
        break
      end
    end
    square
  end

  def position_clear?(position)
    board[position] != player.marker && board[position] != opponent.marker
  end

  def non_winning_decision
    if board.unmarked_keys.include?(5)
      5
    elsif @difficulty == 2
      random_move
    else
      avoid_useless_move
    end
  end

  def avoid_useless_move
    square = nil
    Board::WINNING_LINES.each do |line|
      current_line_markers = find_current_line_markers(line)
      next if current_line_markers.count(opponent.marker) == 1
      line.each do |position|
        if position_clear?(position)
          square = position
          break
        end
      end
    end
    square ? square : random_move
  end
end

class TTTGame
  HUMAN_MARKER = 'X'
  COMPUTER_MARKER = "O"
  FIRST_TO_MOVE = :human

  attr_reader :board, :human, :computer, :current_player

  def initialize
    @board = Board.new
    @human = Player.new(HUMAN_MARKER)
    @computer = Player.new(COMPUTER_MARKER)
    @first_player = FIRST_TO_MOVE == :human ? @human : @computer
    @current_player = @first_player
  end

  def play
    display_welcome_message
    set_names_and_marker
    loop do
      set_game_length_and_difficulty
      display_board
      loop do
        take_turns
        break if game_over?
        display_result
        game_reset
      end
      display_ultimate_result
      play_again? ? match_reset : break
    end
    display_goodbye_message
  end

  private

  def take_turns
    loop do
      current_player_moves
      break if win_or_tie?
      clear_screen_and_display_board if human_turn?
    end
    update_score
  end

  def set_names_and_marker
    set_human_name
    set_computer_name
    record_names
    set_marker
  end

  def display_welcome_message
    puts "Yay! Tic Tac Toe!"
  end

  def set_human_name
    puts "What's your handle, friend?"
    answer = nil
    loop do
      answer = gets.chomp
      break unless answer.nil? || answer.strip == ""
      puts "Sorry, that's confusing for me. Could you maybe try again?"
    end
    human.name = answer
  end

  def set_computer_name
    answer = nil
    print "That's really great, #{human.name}! Could you maybe name me too? "
    puts "I'd really like something to call myself, you know?"
    loop do
      answer = gets.chomp
      break unless answer.nil? || answer.strip == ""
      puts "Sorry, #{human.name}, that's confusing for me. Could you maybe try again?"
    end
    computer.name = answer
  end

  def record_names
    filename = "names.txt"
    File.open(filename, 'a') do |file|
      file.puts human.name
      file.puts computer.name
    end
  end

  def set_marker
    print "Another question - what marker would you like to use? Input"
    puts " any single character except 'O', or just press return for 'X'"
    answer = nil
    loop do
      answer = gets.chomp
      break unless answer.length > 1 || answer == "O"
      print "Those are pretty confusing directions, I understand, but that "
      puts "doesn't work! Try again?"
    end
    human.marker = answer if !answer.empty?
  end

  def set_game_length_and_difficulty
    set_game_length
    set_difficulty
  end

  def set_game_length
    puts "Epic battle or one-off? What score should we play to?"
    answer = nil
    loop do
      answer = gets.chomp
      break if answer == answer.to_i.to_s && answer.to_i > 0
      puts "Hahaha don't be silly, #{human.name}! That won't work!"
    end
    @play_to = answer.to_i
    puts "Gotcha! We'll play to #{@play_to}."
  end

  def set_difficulty
    print "I don't want to be too hard on you! Please select a difficulty from 1"
    puts " (easy) to 3 (not to be immodest, but never been beaten)."
    difficulty = nil
    loop do
      difficulty = gets.chomp
      break if difficulty == difficulty.to_i.to_s && (1..3).cover?(difficulty.to_i)
      print "Only three answers I can understand. So sorry about that, "
      puts "#{human.name}!"
    end
    spawn_ai(difficulty.to_i)
    clear_screen
  end

  def spawn_ai(difficulty)
    @ai = AI.new(difficulty, @computer, @human, @board)
  end

  def display_board
    puts "#{human.name}: #{human.marker}"
    puts "#{computer.name}: #{computer.marker}"
    display_score_and_play_to
    board.draw
  end

  def clear_screen_and_display_board
    clear_screen
    display_board
  end

  def display_score_and_play_to
    puts "The score is #{@human.score} to #{@computer.score}. We're playing to #{@play_to}."
  end

  def current_player_moves
    human_turn? ? human_moves : computer_moves
  end

  def last_move?
    board.unmarked_keys.size == 1
  end

  def human_turn?
    @current_player == @human
  end

  # def human_moves
  #
  #   ### uncomment this method and comment out the other human_moves for
  #   ### level 3 AI control over "human" placement
  #
  #   @humbot ||= AI.new(3, @human, @computer, @board)
  #   @humbot.move
  #   puts "Enter anything for next move"
  #   gets
  #   @current_player = @computer
  # end

  def human_moves
    square = nil
    display_move_prompt
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "Oh man, that's weird, but I don't think you can do that, #{human.name}. Man. Weird!"
    end
    board[square] = human.marker
    @current_player = @computer
  end

  def joinor(arr, separator = ", ", end_word = "or")
    if last_move? == 1
      arr[0]
    elsif arr.length == 2
      "#{arr[0]} #{end_word} #{arr[1]}"
    else
      arr.join(separator).insert(-2, end_word + " ")
    end
  end

  def display_move_prompt
    remaining = board.unmarked_keys
    if last_move?
      puts "Wow, just one left! Hope you don't mind, #{human.name}, you'll have to select #{remaining}"
    else
      puts "OK! Choose just one of these remaining squares: #{joinor(remaining)}"
    end
  end

  def computer_moves
    @ai.move
    @current_player = @human
  end

  def display_result
    clear_screen_and_display_board
    case board.winning_marker
    when human.marker
      puts "Congratulations! You beat me, #{human.name}!"
    when computer.marker
      puts "A win for me, #{computer.name}! Pretty cool!"
    else
      puts "Woops! Neither one of us can move, that's a tie!"
    end
    sleep(1.5)
  end

  def win_or_tie?
    board.someone_won? || board.full?
  end

  def update_score
    case board.winning_marker
    when human.marker then @human.update_score
    when computer.marker then @computer.update_score
    end
  end

  def game_over?
    @human.score == @play_to || @computer.score == @play_to
  end

  def display_ultimate_result
    clear_screen_and_display_board
    case board.winning_marker
    when human.marker
      puts "Wow! You won the whole shebang!"
    when computer.marker
      puts "How about that? I win the match! You did really good though!"
    end
  end

  def play_again?
    answer = ""
    loop do
      puts "That was fun, huh #{human.name}? Should we do it again? (Y/N)"
      answer = gets.chomp.downcase
      break if %w[y n].include? answer
      puts "I'm so sorry, right now I'll only understand Y or N"
    end
    return false if answer == 'n'
    return true if answer == 'y'
  end

  def game_reset
    board.reset
    @current_player = @first_player
    clear_screen_and_display_board
  end

  def match_reset
    clear_screen
    board.reset
    @current_player = @first_player
    @human.score = 0
    @computer.score = 0
    display_play_again_message
  end

  def display_play_again_message
    puts "So cool! #{computer.name} vs. #{human.name}, once again! Here we go!"
  end

  def display_goodbye_message
    print "Ok! Yeah! That was super great, huh? Thanks for playing! "
    print "I'll be right here if you ever need me, #{human.name}..."
    puts "\nyou know that, right?\n\nThank you for giving me a name."
  end
end

game = TTTGame.new
game.play
