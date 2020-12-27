require 'pry'

CHOICES = ['Rock', 'Paper', 'Scissors']

class Player
  attr_accessor :is_human, :move
  
  def initialize(is_h)
    puts "parameter is #{is_h}"
    self.is_human = !!is_h
    self.move = nil
  end
  
  def is_human?
    self.is_human
  end
  
  def choose
    if is_human?
      puts "Pick your move: "
      self.move = gets.chomp
    else
      self.move = CHOICES.sample
    end
  end
end

class Move
  def initialize
  end
end

class Rule
  def initialize
  end
end

def compare(move1, move2)
end

class RPSGame
  attr_accessor :human, :computer
  
  def initialize
    self.human = Player.new(true)
    self.computer = Player.new(false)
  end
  
  def display_welcome_message
    puts "Hello welcome to rock paper scissors"
  end
  
  def display_goodbye_message
    puts "Thanks for playing. Goodbye"
  end
  
  def display_winner
    puts "You chose #{human.move} and Computer chose #{computer.move}"
    
  end
  
  def play_again?
    puts "Play again? (Y/N)"
    gets.chomp.downcase.start_with?('y')
  end
  
  def play
    display_welcome_message
    
    loop do
      human.choose
      computer.choose
      display_winner
      break unless play_again?
    end
    
    display_goodbye_message
  end
end

RPSGame.new.play