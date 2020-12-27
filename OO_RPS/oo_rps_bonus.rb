WINNING_SCORE = 3
# rubocop:disable Lint/MissingSuper

require 'pry'

module GeneralDisplayable
  def clear_screen
    system("cls") || system("clear")
  end

  def display_welcome_greetings
    clear_screen
    puts "=> Welcome to RPSLS game"
    display_winning_score
  end

  def display_goodbye_message
    puts "=> Thank you for playing. Goodbye"
  end

  def display_winning_score
    puts "=> First player to win #{WINNING_SCORE} points wins the game"
  end

  def display_score(player)
    puts "=> #{player.name} : #{player.history.total}"
  end

  def display_round_greetings(player1, player2)
    clear_screen
    puts "=> Game #{player1.history.move_list.size + 1}:
              #{player1.name} vs #{player2.name}"
    display_score(player1)
    display_score(player2)
    display_winning_score
  end

  def display_round_moves(player1, player2)
    player1.display_move
    player2.display_move
  end

  def display_winner(player)
    puts "=> #{player.name.upcase} WON"
  end

  def display_tie
    puts "=> It's a TIE"
  end

  def wait
    puts "=> Press ENTER to continue..."
    gets
  end
end

#==================================================

class Move
  VALUES = ['Rock', 'Paper', 'Scissors', 'Lizard', 'Spock']

  def >(other_move)
    win_if.include?(other_move.value)
  end
end

class Rock < Move
  attr_accessor :value, :win_if

  def initialize
    @value = Move::VALUES[0]
    @win_if = [Move::VALUES[2], Move::VALUES[3]]
  end
end

class Paper < Move
  attr_accessor :value, :win_if

  def initialize
    @value = Move::VALUES[1]
    @win_if = [Move::VALUES[0], Move::VALUES[4]]
  end
end

class Scissors < Move
  attr_accessor :value, :win_if

  def initialize
    @value = Move::VALUES[2]
    @win_if = [Move::VALUES[1], Move::VALUES[3]]
  end
end

class Lizard < Move
  attr_accessor :value, :win_if

  def initialize
    @value = Move::VALUES[3]
    @win_if = [Move::VALUES[1], Move::VALUES[4]]
  end
end

class Spock < Move
  attr_accessor :value, :win_if

  def initialize
    @value = Move::VALUES[4]
    @win_if = [Move::VALUES[0], Move::VALUES[2]]
  end
end

#========================================================

class History
  attr_accessor :move_list, :points

  def initialize
    @move_list = []
    @points = []
  end

  def add_a_move(move)
    @move_list << move
  end

  def total
    @points.sum
  end

  def add_win
    @points << 1
  end

  def add_not_win
    @points << 0
  end
end

#========================================================
class Player
  attr_accessor :name, :move, :history

  def initialize
    choose_name
    @history = History.new
  end

  def choose_from_list(list, choice_type)
    choice = ''
    loop do
      display_list_to_choose_from(list, choice_type)
      user_enter = gets.chomp.downcase.delete(' ')
      choice = categorize(user_enter, list)
      break if choice_confirmed?(choice, list, user_enter)
      puts "=> Invalid choice"
    end
    choice
  end

  def choice_confirmed?(choice, list, user_enter)
    if validated?(choice, list) &&
       ((user_enter == choice.downcase) ||
        (user_enter != choice.downcase &&
                     confirm_data_entry?(choice)))
      return true
    end
    false
  end

  def display_list_to_choose_from(list, choice_type)
    puts "=> Please choose your #{choice_type}:"
    puts "=> #{list.join(', ')}"
  end

  def confirm_data_entry?(choice)
    puts "=> You chose: #{choice}, is this correct? Press Y to confirm."
    answer = gets.chomp
    return false if answer == ''
    answer[0].downcase == 'y'
  end

  def categorize(choice, list)
    return two_chars_match(choice, list) if two_chars_match?(choice, list)
    return one_char_match(choice, list) if one_char_match?(choice, list)
    choice
  end

  def two_chars_match(choice, list)
    list.each do |value|
      return value if choice.start_with?(value[0..1].downcase)
    end
    false
  end

  def two_chars_match?(choice, list)
    !!two_chars_match(choice, list)
  end

  def one_char_match(choice, list)
    list.each do |value|
      return value if choice.start_with?(value[0].downcase)
    end
    false
  end

  def one_char_match?(choice, list)
    !!one_char_match(choice, list)
  end

  def validated?(choice, list)
    list.include?(choice)
  end

  def display_move
    puts "=> #{name} chose #{move.value}"
  end

  def make_move(move)
    @history.add_a_move(move)
  end

  def win
    @history.add_win
  end

  def not_win
    @history.add_not_win
  end
end

# ==========================================================

class Human < Player
  def choose_name
    name = ''
    loop do
      puts "=> Please enter your name:"
      name = gets.chomp.gsub('  ', ' ')
      break if name.gsub(' ', '') != ''
      puts "=> Invalid name"
    end
    @name = name
  end

  def make_move
    @move = Object.const_get(choose_from_list(Move::VALUES, "move")).new
    super(@move)
  end

  def pick_opponent
    choose_from_list(Robot::ROBOT_NAMES, "robot opponent")
  end
end

#======================================================

class Robot < Player
  ROBOT_NAMES = ["Sonny", "R2D2", "BumbleBee", "WallE", "Terminator"]

  def make_move(list)
    @move = Object.const_get(list.sample).new
    super(@move)
  end
end

class Sonny < Robot
  def choose_name
    @name = "Sonny"
    puts "=> Sonny only plays the orginal RPS "
  end

  def make_move(_)
    super(['Rock', 'Paper', 'Scissors'])
  end
end

class R2D2 < Robot
  def choose_name
    @name = "R2D2"
    puts "=> R2D2 loves Scissors"
  end

  def make_move(_)
    super(['Scissors'] * 10 + ['Rock', 'Paper', 'Lizard', 'Spock'])
  end
end

class BumbleBee < Robot
  def choose_name
    @name = "BumblebBee"
    puts "=> BumbleBee likes to copy"
  end

  def make_move(other_player)
    if other_player.history.move_list.size <= 1
      super(Move::VALUES)
    else
      super([other_player.history.move_list[-2].value])
    end
  end
end

class WallE < Robot
  def choose_name
    @name = "Wall-E"
    puts "=> Wall-E overthinks things..."
  end

  def make_move(other_player)
    if other_player.history.move_list.size <= 1
      super(Move::VALUES)
    else
      super(other_player.history.move_list[-2].win_if)
    end
  end
end

class Terminator < Robot
  def choose_name
    @name = "Terminator"
    puts "=> Terminator hates Spock"
  end

  def make_move
    super(['Rock', 'Paper', 'Scissors', 'Lizard'])
  end
end

#==================================================

class RPSGame
  attr_accessor :human, :computer

  include GeneralDisplayable

  def play
    display_welcome_greetings
    pick_players
    wait
    loop do
      play_a_round
      break if someone_win?(human, computer)
      wait
    end
    decide_overall_winner(human, computer)
    display_goodbye_message
  end

  def someone_win?(player1, player2)
    return true if player1.history.total == WINNING_SCORE ||
                   player2.history.total == WINNING_SCORE
    false
  end

  def pick_players
    @human = Human.new
    @computer = Object.const_get(human.pick_opponent).new
  end

  def play_a_round
    display_round_greetings(human, computer)
    human.make_move
    computer.make_move(human)
    human.display_move
    computer.display_move
    compare_moves(human, computer)
  end

  # rubocop:disable Metrics/MethodLength
  def compare_moves(player1, player2)
    if player1.move > player2.move
      player1.win
      player2.not_win
      display_winner(player1)
    elsif player2.move > player1.move
      player2.win
      player1.not_win
      display_winner(player2)
    else
      player1.not_win
      player2.not_win
      display_tie
    end
  end
  # rubocop:enable Metrics/MethodLength

  def decide_overall_winner(player1, player2)
    winner = if player1.history.total == WINNING_SCORE
               player1
             else
               player2
             end
    wait
    clear_screen
    display_score(player1)
    display_score(player2)
    puts "=> #{winner.name.upcase} WON THE OVERALL GAME"
  end
end

RPSGame.new.play
# rubocop:enable Lint/MissingSuper
