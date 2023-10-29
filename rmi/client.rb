require 'drb/drb'

URI = 'druby://localhost:3000'

class CoupChallengeClient
  def initialize(name, uri)
    @player_name = name
    @server = DRbObject.new_with_uri(uri)
  end

  def play
    options = [1,2,3]
    while true
      score = 0
      options_sorted_number = @server.shuffle(options)
      send("draw_cups_with_balls_#{options_sorted_number}_option")

      puts "Shuffling..."
      puts "\n"

      puts "Where is the ball?"
      puts "options: 1, 2, 3"
      answer = gets.chomp
      real_sorted_number = @server.shuffle(options)
      if (answer.to_s == real_sorted_number.to_s)
        puts "CORRECT!!!!!!!!!"
        score += 1
      else
        puts "WRONG!!!!!!!!!"
      end

      send("draw_cups_with_balls_#{real_sorted_number}_option")
      puts "Other Round? (y/n)"
      continue_answer = gets.chomp

      if continue_answer.downcase != "y"
        puts "#{@player_name} score: #{score}"
        break
      end
    end
  end

  def draw_cups_with_balls_1_option
    cups = <<~CUPS
       ______       ______      ______
      /      \\     /      \\    /      \\
      |  O   |     |      |    |      |
      |      |     |      |    |      |
      \\______/     \\______/    \\______/
    CUPS
    puts cups
  end

  def draw_cups_with_balls_2_option
    cups = <<~CUPS
       ______       ______      ______
      /      \\     /      \\    /      \\
      |      |     |  O   |    |      |
      |      |     |      |    |      |
      \\______/     \\______/    \\______/
    CUPS
    puts cups
  end

  def draw_cups_with_balls_3_option
    cups = <<~CUPS
       ______       ______      ______
      /      \\     /      \\    /      \\
      |      |     |      |    |  O   |
      |      |     |      |    |      |
      \\______/     \\______/    \\______/
    CUPS
    puts cups
  end
end

puts "Enter your username: \n"
username = gets.chomp

coup_challenge = CoupChallengeClient.new(username, URI)
coup_challenge.play