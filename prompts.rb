class Prompts
  def self.voiced_prompt
    @voiced_prompt
  end
  @voiced_prompt = {
                     stay: ERB.new("<% Participant.name.upcase %> STAYS."),
                     show: ERB.new("<% Participant.name.upcase %> SHOWS <% hand.join(', ')} %>"),
                     h_or_s: "YOU MUST CHOOSE [H]IT or [S]TAY",
                     h_or_s_error: "THAT IS NOT A VALID INPUT. ERROR. RETRY.",
                     dealer_hits: "DEALER MUST HIT",
                     dealer_busts: "DEALER BUSTS",
                     dealer_stays: "DEALER STAYS",
                     welcome_message: "HELLO. IT IS 21.",
                     initial_player_hand: ERB.new("IN YOUR HAND IS <% @player.hand[0] %> AND <% @player.hand[1] %>."),
                    # initial_dealer_hand: ERB.new("THE DEALER IN TURN SHOWS " +
                    #                       "#{@dealer.hand[0]}."),
                    # goodbye: "AND SO IT ENDS.",
                    # player_stays: ERB.new("YOU STAY AT #{player.total}"),
                    # winning_score: ERB.new("#{player.total}. DEALER CANNOT BEAT THAT AND" +
                    #                 " AT BEST CAN TIE."),
                    # outcome_p_bust: ERB.new("YOU BUSTED WITH #{player.total}. IT IS" +
                    #                       " COMMON. YOU LOSE"),
                    # outcome_d_bust: ERB.new("DEALER BUSTED WITH #{dealer.total}. " +
                    #                       "YOU HAVE WON"),
                    # outcome_tie: "UNCOMMON BUT NOT REMARKABLE: A TIE",
                    # outcome_dealer_win: ERB.new("AT #{player.total} TO #{dealer.total} " +
                    #                     "YOU WERE BEATEN BY THE DEALER IN " +
                    #                     "ACCORDANCE WITH THE RULES"),
                    # play_again: "ANOTHER GAME IS POSSIBLE. INPUT YOUR CHOICE: " +
                    #             "Y OR N.",
                    # play_again_error: "INVALID. Y OR N. ERROR. RETRY.",
                    # new_game: ERB.new("BEGINNING GAME #{@game_count}.")
    }
    
  #   @@generic_prompt = {
  #                     stay: "#{name.upcase} stays.",
  #                     show: "#{name.upcase} shows #{hand.join(', ')}",
  #                     h_or_s: "Please choose [H}it or [S]tay",
  #                     h_or_s_error: "Sorry, I didn't understand. Please try again.",
  #                     dealer_hits: "Dealer hits.",
  #                     dealer_stays: "Dealer stays.",
  #                     welcome_message: "Welcome to 21!",
  #                     initial_player_hand: "You have #{@player.hand[0]} and " +
  #                                         "#{@player.hand[1]}.",
  #                     initial_dealer_hand: "Dealer shows #{@dealer.hand[0]}.",
  #                     goodbye: "Thanks for playing 21!",
  #                     player_stays: "You stay at #{player.total}",
  #                     winning_score: "How got #{player.total}. How about that!",
  #                     outcome_p_bust: "You bust at #{player.total}. You lose.",
  #                     outcome_d_bust: "Dealer busts at #{dealer.total}. You win.",
  #                     outcome_tie: "#{player.total} to #{dealer.total}. A tie!",
  #                     outcome_dealer_win: "#{player.total} to #{dealer.total}. " +
  #                                         "Dealer wins.",
  #                     play_again: "Play again? [Y/N]",
  #                     play_again_error: "Sorry, I didn't understand. Please try " +
  #                                       "again.",
  #                     new_game: "Beginning game #{@game_count}."
  #   }
  end