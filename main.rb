# frozen_string_literal: true

require_relative 'hangman'

hm = Hangman.new

while hm.remaining_turn.positive? && !hm.secret_word_guessed?
  puts "You have #{hm.remaining_turn} remaining turns."

  puts 'Enter one character that you think would be in this word:'
  input = gets.chomp
  input = '' if input.length != 1
  hm.check_input(input)
  hm.view_progress
end

if hm.secret_word_guessed?
  puts 'Well done, you guessed it!'
else
  puts "No turns left to guess. The secret word is #{hm.secret_word}."
end
