# frozen_string_literal: true

require_relative 'hangman'
require_relative 'hangman_graphics'

saved_game_path = './game_saves'

puts 'Welcome to Hangman.'
puts 'See below and enter the number of your choice'
puts '1. Play'
puts '2. Load'
puts '3. Exit'

input = gets.chomp.to_i

case input
when 1
  hm = Hangman.new
when 2
  current_saved_game = Dir.entries(saved_game_path)
  # remove '..' and '.' from this array
  current_saved_game.delete('..')
  current_saved_game.delete('.')

  if current_saved_game.empty?
    puts "Nothing was saved previously. Let's start a new one.\n\n"
    hm = Hangman.new
  else
    puts "Enter the index of the file that you'd like to load"
    current_saved_game.each_with_index do |filename, index|
      puts "#{index}. #{filename}"
    end
    index = gets.chomp.to_i
    filename = current_saved_game.fetch(index, 'invalid')

    until filename != 'invalid'
      puts 'Index entered is invalid. Please try again:'
      index = gets.chomp.to_i
      filename = current_saved_game.fetch(index, 'invalid')
    end

    filename_path = "#{saved_game_path}/#{filename}"
    json_string = File.readlines(filename_path)[0]
    hm = Hangman.from_json(json_string)
  end
when 3
  puts 'Bye!'
else
  puts 'Invalid input. Exiting.'
end

status = ''
if [1, 2].include?(input)
  while hm.remaining_turn.positive? && !hm.secret_word_guessed?
    puts HANGMAN_STAGES[hm.remaining_turn]
    hm.view_progress

    puts "You have #{hm.remaining_turn} turns remaining."
    puts "Previous guesses: #{hm.guessed_characters.join(', ')}"
    puts "Enter one character that you think would be in this word, the word itself, or 'save!' to save the game:"
    input = gets.chomp

    status = hm.check_input(input)
    case status
    when :character_guessed
      puts "You've guessed #{input} already."
    when :saved
      puts 'Game saved!'
      hm.save_game
      break
    end
    puts "\n\n"
  end

  if hm.secret_word_guessed?
    if hm.word_guessed_in_full
      puts 'Impressive, you guessed the word in full!'
    else
      puts "Well done, you've guessed it!"
    end
  else
    unless status == :saved
      puts HANGMAN_STAGES[hm.remaining_turn]
      puts "No turns left to guess. The secret word is #{hm.secret_word}."
      puts 'As a punishment, do dead hang for 5 seconds, then perform 2 repetitions of pull-up or one of its variants.'
    end
  end
end
