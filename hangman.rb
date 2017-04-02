require "csv"

class Hangman

  def initialize
    list=File.readlines "5desk.csv"
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

  def gameplay
    while @display_word.include? "_"
    display
    guess
    end
    puts "Congratulations. The word was #{@word}"
  end

  def display
    puts "#{@display_word}"
        puts "Wrong letters: #{@wrong_letters}"
    puts "Remaining guess: #{@counter}"
    @counter-=1
  end

  def guess
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