# frozen_string_literal: true

require 'base64'
require 'fileutils'
require 'json'

# Hold most of the logic for this game
class Hangman
  attr_reader :remaining_turn
  attr_accessor :secret_word, :current_progress, :guessed_characters, :word_guessed_in_full

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
    word.downcase
  end

  # return message
  def check_input(input)
    return :character_guessed if guessed_characters.include?(input)

    if input == 'save!'

      :saved
    elsif input == secret_word
      @current_progress = input.chars
      @word_guessed_in_full = true
    elsif input.length == secret_word.length
      @remaining_turn -= 1
      guessed_characters.add(input)
    else
      input = sanitize_input(input)

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

  # discarding args
  def to_json(*_args)
    JSON.dump({
                remaining_turn: @remaining_turn,
                secret_word: Base64.strict_encode64(@secret_word),
                # regular encode64 adds a line feed to every 60 encoded char which shouldn't be a problem
                # since the secret word won't be that long
                # but let's use strict anyway for better consistency.
                current_progress: @current_progress,
                word_guessed_in_full: @word_guessed_in_full,
                guessed_characters: @guessed_characters.to_a # convert set to array for storage
              })
  end

  def self.from_json(json)
    json = JSON.parse(json)

    hm = Hangman.new(json['remaining_turn'])
    hm.secret_word = Base64.strict_decode64(json['secret_word'])
    hm.current_progress = json['current_progress']
    hm.word_guessed_in_full = json['word_guessed_in_full']
    hm.guessed_characters = Set.new(json['guessed_characters'])

    hm
  end

  def save_game
    FileUtils.mkdir_p('./game_saves') # good - atomic and idempotent creation
    filename = "#{current_progress.join}-#{secret_word.length}letters-#{remaining_turn}turnsleft.json"
    f = File.new "./game_saves/#{filename}", 'w' # overwrite previous saved game if there is one
    f.puts(to_json)
    f.close
  end

  private

  def sanitize_input(input)
    input.downcase!
    return input[0] if input.length != 1

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
