require 'test/unit'
require_relative 'blackjack'

class MyTest < Test::Unit::TestCase

  # def setup
  # end

  # def teardown
  # end

  def test_calculate_hand_1

    the_hand = [
      { value: "King", suit: "Spade" },
      { value: 8,      suit: "Heart" }
    ]

    assert_equal(18, calculate_hand(the_hand))

  end

  def test_calculate_hand_2

    the_hand = [
        { value: "Jack",  suit: "Club"  },
        { value: "Queen", suit: "Heart" }
    ]

    assert_equal(20, calculate_hand(the_hand))

  end


end
