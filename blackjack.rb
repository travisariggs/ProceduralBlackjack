#@@@@@@@@@@@@ Variables @@@@@@@@@@@@@@@
NUM_OF_DECKS = 2
MIN_SHOE_SIZE = 12



#$$$$$$$$$$$ Methods $$$$$$$$$$$$$$$$$$
def calculate_hand(hand)

  total = 0

  hand.each do |card|

    if card[:value] == 'King'
      total += 10
    elsif card[:value] == 'Queen'
      total += 10
    elsif card[:value] == 'Jack'
      total += 10
    elsif card[:value] == 'Ace'
      next
    else
      total += card[:value]
    end

    # TODO: Handle Aces differently

  end

  total

end

def shuffle_cards(card_array)



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
  # TODO:

  return the_shoe

end

def say(message)

  puts
  puts message.to_s
  puts

end

def get_wager(total_money)

  # Make sure we keep asking until we get a valid bet
  while true

    say 'How much would you like to bet?'
    bet = gets.chomp

    if bet.to_i == 0
      say 'You have to bet something'
    elsif bet.to_i > total_money
      puts "You don't have that much money"
      puts "You can bet a max of #{total_money}"
    else
      return bet.to_i
    end

  end

end

def show_cards(hand, mask=false)

  puts 'Your hand is:'

  hand.each do |card|
    unless mask
      puts "#{card}"
    end
  end

  total = calculate_hand(hand)
  
  puts "Total: #{total}"

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
  while true

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
    show_cards(dealer_hand, mask=true)
    show_cards(user_hand)

    # Check totals here to see if there was blackjack
    user_total = calculate_hand(user_hand)

    user_status = hand_status?(user_total)

    # Loop through user 'hits'
    while user_status == 'Playing'

      say "Would you like a hit, #{user}? (y/n)"
      response = gets.chomp.downcase

      if response == 'y'

        user_hand << shoe.pop

        # Calculate hand again...did we get to 21?
        user_total = calculate_hand(user_hand)

        show_cards(user_hand)

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
      money += wager * 1.5
    elsif user_status == 'Bust'
      say "Sorry #{user}...you busted"
      money -= wager
    else
      show_cards(user_hand)
    end

    # Now it's the dealer's turn...
    # TODO

    # Show results of betting
    say "#{user}, your money remaining: $#{money}"

    say "Would you like to play another round, #{user}? (y/n)"
    again = gets.chomp.downcase

    if again == 'n'
      break
    end

  end

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



