=begin
  Goal: When a new game is started, your script should load in the dictionary
  and randomly select a word between 5 and 12 characters long for the secret word.
  
  Start game: 
    Pick random word from txt file
    Put intro array (correct answer)

    - Intro to the game of hangman, rules and guess
  - display number of blanks 

  Display: Number of blanks and correct letters
    Create blank array given correct answer, blanks = array length


  On turn: Prompt user to guess (case insensitive) 
    ask prompt
    case insensitive
      
      Check on guess with correct answer (includes)
        if letter is in arrray, add to blank range. 
          both cases, put letter in used range 
      

  Remind user if letter has already been used

  Draw: Stick figure (mechanism to determine how many guess are incorrect)
  
      ----+
      |   |
      O   |
      \ /  |
      |   |
      / \  |

  Function to save game 
    
  Function to load game
=end

# 1/2 Add logic for updating hangman guess with guessed letter
# 1/3 Put option to guess entire word or lose 
  #Make method to reduce duplicates in past_guesses
  #1/4 - Put in option to save game! - done

  #1/11 - get rid of save game as part of past guess array
  # Figure out how to open saved gaemd 

  def pick_random_word
    # Read word document, randomly pick word, assign to array, create $game_word)array
    random_words_array = File.read('5desk.txt').downcase.split(" ")
    random_seed = rand(1..random_words_array.length)
    $game_word = random_words_array[random_seed]
    $game_word_array = $game_word.split("")
  end
  
  def begin_game
    puts "Welcome to Hangman! A random word has been chosen. Please guess a letter
    to spell the word."
    
    #creates the array with all the blanks
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
  
  
  def turn
    $turn_number = 1
    $past_guesses = []
    $wrong_guess_number = 0 
    number_correct = 0
  
    while $wrong_guess_number < 6 and number_correct != $blank_array.length
      puts "For turn #{$turn_number}, what is your guess?"
      guess = gets.chomp.downcase.to_s
      
      #just in case
      while guess.length > 1 and guess != "save game"
        puts " Not too many letters!"
        guess = gets.chomp.downcase.to_s
      end
      # if game word includes letter at all, initatite if loop 
      # if game word doesn't include letter at all..... dont?
  
      i = 0
      # $game_word_array.include?(guess)
      
      # Figure out method for checking array position of letter in each do method
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
    
  
    if $wrong_guess_number.to_s.to_i >= 6
      puts "Looks like the game is over! You're out of turns! The word was #{$game_word}." 
    end
  
  end
  
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