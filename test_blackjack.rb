require 'test/unit'
require_relative 'blackjack'


class TestCalculateHand < Test::Unit::TestCase

  # def setup
  # end

  # def teardown
  # end

  def test_king_8
    the_hand = [
      { value: 'King', suit: 'Spade'},
      { value:      8, suit: 'Heart'}
    ]

    assert_equal(18, calculate_hand(the_hand))
  end

  def test_jack_queen
    the_hand = [
        { value:  'Jack', suit: 'Club'  },
        { value: 'Queen', suit: 'Heart' }
    ]
    assert_equal(20, calculate_hand(the_hand))
  end

  def test_10_ace
    the_hand = [
        { value:    10, suit: 'Club'  },
        { value: 'Ace', suit: 'Heart' }
    ]
    assert_equal(21, calculate_hand(the_hand))
  end

  def test_ace_5_10
    the_hand = [
        { value: 'Ace', suit: 'Heart'   },
        { value:     5, suit: 'Diamond' },
        { value:    10, suit: 'Club'    },
    ]
    assert_equal(16, calculate_hand(the_hand))
  end

  def test_ace_ace_10_7
    the_hand = [
        { value: 'Ace', suit: 'Heart'   },
        { value: 'Ace', suit: 'Diamond' },
        { value:    10, suit: 'Club'    },
        { value:     7, suit: 'Club'    }
    ]
    assert_equal(18, calculate_hand(the_hand))
  end

end


class TestShuffle < Test::Unit::TestCase

  # def setup
  # end

  # def teardown
  # end

  def test_length
    shoe = create_shoe(2)
    assert(false)
  end

end


class TestCreateShoe < Test::Unit::TestCase

  def test_1_deck_length
    shoe = create_shoe(1)
    assert_equal(52, shoe.length)
  end

end


class TestHandStatus < Test::Unit::TestCase

  def test_blackjack
    assert_equal('Blackjack', hand_status?(21))
  end

  def test_bust_22
    assert_equal('Bust', hand_status?(22))
  end

  def test_bust_27
    assert_equal('Bust', hand_status?(27))
  end

  def test_playing_7
    assert_equal('Playing', hand_status?(7))
  end

end