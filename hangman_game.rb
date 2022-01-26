=begin
- Update way to open save state
- put option to guess entire word or lose 
- Make sure save game is not part of guess array
- Weird issue with duplicate letters, look into 
=end

# Read word document, randomly pick word, assign to array, create $game_word)array
def pick_random_word
  random_words_array = File.read('5desk.txt').downcase.split(" ")
  random_seed = rand(1..random_words_array.length)
  $game_word = random_words_array[random_seed]
  $game_word_array = $game_word.split("")
end

#Creates the array with all the blanks
def begin_game
  puts "Welcome to Hangman! A random word has been chosen. Please guess a letter
  to spell the word."
  
  i = 0 
  $blank_array = []
  while i < $game_word.length
    $blank_array[i] = "_ "
    i+=1
    if i < $game_word.length
      $blank_array[i] = "_ "
      i+=1
    elsif i = ($game_word.length - 1)
      $blank_array[i] = "_"
      i+=1
    elsif i >= $game_word.length
      break
    end
  end

  puts $blank_array.join
  
end

# Promps user to guess, changes turn count, pass guesses, and wrong guesses
def turn
  $turn_number = 1
  $past_guesses = []
  $wrong_guess_number = 0 
  number_correct = 0

  while $wrong_guess_number < 6 and number_correct != $blank_array.length
    puts "For turn #{$turn_number}, what is your guess?"
    guess = gets.chomp.downcase.to_s
    
    while guess.length > 1 and guess != "save game"
      puts " Not too many letters!"
      guess = gets.chomp.downcase.to_s
    end

    i = 0
    
    $game_word_array.each_with_index do |letter, index|
      if $game_word_array.include?(guess) and unless $past_guesses.include?(guess)
        if letter == guess
          $blank_array[index] = guess
          number_correct += 1
          $past_guesses.push(guess)
          $unique_past_guesses = $past_guesses.uniq.sort
          puts "_____________________________________________________
          Yes, there is a #{guess}"
        end
      end
    end

    if guess.include?("save game")
      File.open("save.txt", "w") { |f| f.write(
        "The game word is #{$game_word_array}. \n
        The past guesses are #{$unique_past_guesses} \n
        The word so far is #{$blank_array}. \n
        The current turn is #{$turn_number}. \n
        The number of wrong guess is #{$wrong_guess_number}.\n") }
        puts "Your game has been saved."
      end
    end

    if $past_guesses.include?(guess)
      puts "You've already entered that letter"
    end

    unless $game_word_array.include?(guess) 
      puts "_______________________________________________
      No, there is not a #{guess}"
      $wrong_guess_number += 1
      $past_guesses.push(guess)
      $unique_past_guesses = $past_guesses.uniq.sort
    end

      display_hangman()
      $turn_number += 1
      puts $blank_array.join
      $past_guesses.sort.uniq


      puts "Your past guess are #{$unique_past_guesses}"
    end
    
  if $game_word == $blank_array
    puts "You're correct! The word is #{$game_word}!"
  end
  
# Turn counter to game over
  if $wrong_guess_number.to_s.to_i >= 6
    puts "Looks like the game is over! You're out of turns! The word was #{$game_word}." 
  end

end

# display hangman, more body parts are shown as wrong guesses increase
def display_hangman
  if $turn_number.to_s.to_i < 20
    puts " +----+"
    puts " |    |"
    puts " #{$wrong_guess_number.to_s.to_i >= 1 ? "O" : " "}    |"
    puts "#{$wrong_guess_number.to_s.to_i >= 2 ? '\ ' : "  " }#{$wrong_guess_number.to_s.to_i >= 3 ? "/" : " "}   |"
    puts " #{$wrong_guess_number.to_s.to_i >= 4 ? "|" : " "}    |"
    puts "#{$wrong_guess_number.to_s.to_i >= 5 ? "/ " : "  "}#{$wrong_guess_number.to_s.to_i >= 6 ? '\   ' : "   "} |"
  end
end


pick_random_word
display_hangman
begin_game
turn