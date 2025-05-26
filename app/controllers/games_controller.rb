require "json"
require "open-uri"

class GamesController < ApplicationController
  def new
    @letters = ('A'..'Z').to_a.sample(10)
  end

  def score
    # Count the number of occurrences of each letter in the grid
    word = params[:word].upcase
    @letters = params[:letters].split
    letter_counts = {}
    @letters.each do |letter|
      if letter_counts.key?(letter)
        letter_counts[letter] += 1
      else
        letter_counts[letter] = 1
      end
    end
    # The word can’t be built out of the original grid
    word_ok = true
    word.each_char do |letter|
      if letter_counts.key?(letter) && letter_counts[letter] > 0
        letter_counts[letter] -= 1
      else
        word_ok = false
      end
    end
    if word_ok && valid_word?(word)
      @result = "Congratulations! '#{word}' is a valid word."
    elsif word_ok
      @result = "Sorry but '#{word}' is not a valid English word."
    else
      @result = "Sorry but '#{word}' cannot be built out of the grid."
    end
    # The word is valid according to the grid, but is not a valid English word
    # The word is valid according to the grid and is an English word
  end

  private

  def valid_word?(word)
    url = "https://dictionary.lewagon.com/#{word.downcase}"
    dictionary = JSON.parse(URI.parse(url).read)
    dictionary["found"]
  end
end
