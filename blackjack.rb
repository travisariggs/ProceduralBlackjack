#@@@@@@@@@@@@ Variables @@@@@@@@@@@@@@@
NUM_OF_DECKS = 2
MIN_SHOE_SIZE = 12



#$$$$$$$$$$$ Methods $$$$$$$$$$$$$$$$$$
def calculate_hand(hand)

  total = 0
  ace_count = 0

  hand.each do |card|

    if ['King', 'Queen', 'Jack'].include?(card[:value])
      total += 10
    elsif card[:value] == 'Ace'
      ace_count += 1
    else
      total += card[:value]
    end

  end

  # Add the Aces as 11's
  total += ace_count * 11

  # Check to see if it's a bust
  #  and reduce the '11' to a '1'
  #  until we run out of aces or
  #  the total goes 21 or below
  if total > 21

    ace_count.times do

      # Change the 11 to a 1
      total -= 10

      # Check the total again
      if total <= 21
        break
      end

    end

  end

  # We've now changed as many aces
  #  to values of 1's that we could,
  #  (if we had any at all)
  total

end


def shuffle_cards(card_array)

  card_array.shuffle

end

def create_shoe(decks)

  the_shoe = []

  decks.times do

    [ 'Club', 'Diamond', 'Heart', 'Spade'].each do |suit|

      ((2..10).to_a + ['Jack', 'Queen', 'King', 'Ace']).each do |card|

        # Insert a hash of the card value and the suit
        the_shoe << {suit: suit, value: card}

      end

    end

  end

  # Shuffle the cards in the shoe
  the_shoe = shuffle_cards(the_shoe)

end

def say(message)

  puts
  puts ' '*10 + message.to_s
  puts

  sleep(2.0)

end

def get_wager(total_money)

  # Make sure we keep asking until we get a valid bet
  while true

    say 'How much would you like to bet?'
    bet = gets.chomp

    if bet.to_i == 0
      say 'You have to bet something'
    elsif bet.to_i > total_money
      puts "You don't have that much money."
      puts "You can bet a max of $#{total_money}."
    else
      return bet.to_i
    end

  end

end

def get_y_n_answer(question, correction='You need to answer y or n')
  # Ask a yes or no question until the user provides a 'y' or 'n'
  #  Returns a string 'y' or 'n'
  #  On a failure, it could possibly return nil

  response = nil

  # Keep asking until we get a proper response
  while true

    say question
    response = gets.chomp.downcase

    if ['y', 'n'].include?(response)
      break
    else
      say correction
    end

  end

  response

end

def show_cards(hand, name, mask=false)

  total = calculate_hand(hand)

  puts
  if mask
    puts "   #{name}'s hand is: ??"
  else
    puts "   #{name}'s hand is: #{total}"
  end

  hand.each_with_index { | card, index |
    # Hide the second card if mask is true
    if mask && index == 1
      puts ' '*10 + " *** Hidden Card *** "
    else
      puts ' '*10 + "  #{ card[:value] } of #{ card[:suit] }'s"
    end
  }

  # Add some delay to make it easier for the user
  #  to keep up with what is happening
  sleep(2.5)

end

def hand_status?(hand_total)

  if hand_total == 21
    status = 'Blackjack'
  elsif hand_total > 21
    status = 'Bust'
  else
    status = 'Playing'
  end

end



########## Main Program ##################
if __FILE__ == $0

  # Ask who's playing
  say ' '*10 + 'Welcome to Blackjack!'
  say "What's your name?"

  user = gets.chomp

  # Be friendly...even though you're going to take their money
  say "Hello #{user}!  Nice to meet you!"

  # How much money will they start with?
  say 'How much money would you like to convert?'

  money = gets.chomp.to_i
  starting_money = money

  # Fill the card shoe with shuffled cards
  shoe = create_shoe(NUM_OF_DECKS)


  # Loop through each hand that the user wants to play
  #  ...as long as they have money, of course...
  while money > 0

    # Make sure we have enough cards left in the shoe
    if shoe.size < MIN_SHOE_SIZE
      shoe = create_shoe(NUM_OF_DECKS)
    end

    # Ask for the user's bet
    wager = get_wager(money)

    # It's time to deal the initial cards
    user_hand = []
    dealer_hand = []

    user_hand << shoe.pop
    dealer_hand << shoe.pop

    user_hand << shoe.pop
    dealer_hand << shoe.pop

    # Display cards
    show_cards(dealer_hand, 'Dealer', mask=true)
    show_cards(user_hand, user)

    # Check totals here to see if there was blackjack
    user_total = calculate_hand(user_hand)

    user_status = hand_status?(user_total)

    # Loop through user 'hits'
    while user_status == 'Playing'

      response = get_y_n_answer("Would you like a hit, #{user}? (y/n)")

      if response == 'y'

        user_hand << shoe.pop

        # Calculate hand again...did we get to 21?
        user_total = calculate_hand(user_hand)

        show_cards(user_hand, user)

        # Get user status
        user_status = hand_status?(user_total)

      elsif response == 'n'

        break

      else

        next

      end

    end

    # How did the user do?
    if user_status == 'Blackjack'
      say 'Blackjack baby!'
    elsif user_status == 'Bust'
      say "Sorry #{user}...you busted"
    else
      show_cards(user_hand, user)
    end

    # Now it's the dealer's turn...(unless the user had Blackjack or bust)
    show_cards(dealer_hand, 'Dealer')

    if user_status == 'Playing'

      # Check totals here to see if there was blackjack
      dealer_total = calculate_hand(dealer_hand)

      # Loop through user 'hits'
      while dealer_total < 17

        say 'Dealer takes a hit...'
        dealer_hand << shoe.pop

        # Calculate hand again...did we get to 21?
        dealer_total = calculate_hand(dealer_hand)

        show_cards(dealer_hand, 'Dealer')

      end

    end

    # Determine who wins
    # win_status = determine_winner(user_total, dealer_total)

    # update the gains/losses
    if user_status == 'Blackjack'
      say "#{user}, you won!"
      money += wager * 1.5
    elsif user_status == 'Bust'
      say 'You lost this round.'
      money -= wager
    elsif user_total > dealer_total || dealer_total > 21
      say "#{user}, you won!"
      money += wager
    elsif user_total < dealer_total
      say "Sorry #{user}, you lost this time."
      money -= wager
    elsif user_total == dealer_total
      say "It's a push."
    else
      say "SOMETHING WENT TERRIBLY WRONG!"
    end

    # Show results of betting
    say "#{user}, you have $#{money} left."

    # Make decisions about the next round
    break if money == 0

    answer = get_y_n_answer("Would you like to play another round, #{user}? (y/n)")

    break if answer == 'n'

  end  # End the Game Loop

  # Tell the user how they fared
  say "You started with $#{starting_money} and ended with $#{money}."

  if money > starting_money
    say "Congratulations, #{user}!"
  else
    say 'Sorry about your luck...'
  end

  # Say goodbye!
  say "Thanks for playing #{user}! Come back soon!"

end



