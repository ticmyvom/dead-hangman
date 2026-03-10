# frozen_string_literal: true

# Hold most of the logic for this game
class Hangman
  attr_reader :remaining_turn, :word_guessed_in_full
  attr_accessor :secret_word, :current_progress, :guessed_characters

  def initialize(turn = 8)
    # have a function that display the status depending on how many turns remain?
    @remaining_turn = turn
    @secret_word = pick_a_word_from_file
    @current_progress = Array.new(secret_word.length, '_')
    @word_guessed_in_full = false
    @guessed_characters = Set.new
  end

  def pick_a_word_from_file(filepath = './google-10000-english-no-swears.txt')
    word = ''
    lines = File.readlines(filepath)
    word = lines.sample.strip until word.length.between?(5, 12)
    word
  end

  # return message
  def check_input(input)
    if input == secret_word
      @current_progress = input.chars
      @word_guessed_in_full = true
    else
      input = sanitize_input(input)

      return :character_guessed if guessed_characters.include?(input)

      indices = locate_indices(input)
      if indices.empty?
        @remaining_turn -= 1
      else
        update_progess(input, indices)
      end
      guessed_characters.add(input)
    end
  end

  def view_progress
    @current_progress.each { |letter| print "#{letter} " }
    puts ''
  end

  def secret_word_guessed?
    current_progress.join == secret_word
  end

  private

  def sanitize_input(input)
    return '' if input.length != 1

    input
  end

  def locate_indices(input_char)
    indices = []
    secret_word.chars.each_with_index do |char, index|
      indices.append(index) if char == input_char
    end
    indices
  end

  def update_progess(input_char, indices)
    indices.each { |index| @current_progress[index] = input_char }
  end
end
