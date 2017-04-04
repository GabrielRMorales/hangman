require "csv"
require "yaml"

class Hangman

  def initialize
    list=File.readlines "5desk.csv"    
    ask_to_load
    @word=list.sample    
    while @word.length<5 || @word.length>12
      @word=list.sample
    end    
    @display_word=String.new
    (@word.length-1).times do 
    @display_word<<"_"
    end   
    @wrong_letters=[]
    @counter=@word.length
    puts "#{@word}"
    gameplay
  end

  def ask_to_load
    puts "Want to load your previous game? Y/N"
    choice=gets.chomp
    if choice.upcase=="Y"
      load
      gameplay
    else
      initialize
    end
  end

  def gameplay
    while @display_word.include? "_"
    display
    puts "Want to save this game? Y/N"
    choice=gets.chomp
    if choice.upcase=="Y"
      save
      guess
    else
    guess
    end
    end
    puts "Congratulations. The word was #{@word}"
  end

  def save
    saved_game={ :word=>@word,
      :display_word=>@display_word,
      :wrong_letters=>@wrong_letters,
      :counter=>@counter
    }
    File.open("save-file.yml","r+") do |f|
      f.write(saved_game.to_yaml)
    end
  end

  def load
    loaded_game=YAML.load_file("save-file.yml")
    @word=loaded_game[:word]
    @display_word=loaded_game[:display_word]
    @wrong_letters=loaded_game[:wrong_letters]
    @counter=loaded_game[:counter]
  end

  def display
    puts "#{@display_word}"
        puts "Wrong letters: #{@wrong_letters}"
    puts "Remaining guess: #{@counter}"
    @counter-=1
  end

  def guess
    #bug occurs with the first letter checking a capital
    puts "Guess a letter"
    user_guess=gets.chomp
    puts "You guessed #{user_guess}"
    word_check=@word.clone
    if @word.include? (user_guess)
      @word.each_char do |char|
        if char==user_guess.upcase || char==user_guess.downcase
          @display_word[word_check.index(char)]=char
          word_check[word_check.index(char)]="_"
        end
      end
    else
      @wrong_letters.push(user_guess)
    end
  end

end
game=Hangman.new