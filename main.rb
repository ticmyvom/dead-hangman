# frozen_string_literal: true

require_relative 'hangman'

hm = Hangman.new
while hm.remaining_turn.positive? && !hm.secret_word_guessed?
  puts "You have #{hm.remaining_turn} remaining turns."

  puts 'Enter one character that you think would be in this word or the word itself:'
  input = gets.chomp

  hm.check_input(input)
  hm.view_progress
end

if hm.secret_word_guessed?
  if hm.word_guessed_in_full
    puts 'Impressive, you guessed the word in full!'
  else
    puts 'Well done, you guessed it!'
  end
else
  puts "No turns left to guess. The secret word is #{hm.secret_word}."
  puts 'As a punishment, do dead hang for 5 seconds and then perform 2 repetitions of pull-up or one of its variants.'
end
