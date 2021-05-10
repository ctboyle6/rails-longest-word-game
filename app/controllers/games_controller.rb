require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    alphabet = ('A'..'Z').to_a
    @letters = []

    10.times do
      @letters << alphabet.sample
    end
  end

  def score
    attempt = params[:answer]
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    dictionary_serial = open(url).read
    dictionary_json = JSON.parse(dictionary_serial)
    @response = ''

    unless check_validity(attempt) && check_letter_overuse(attempt)
      @response = dictionary_json[:found] == false ? 'not an English word!' : "cannot be built out of #{@letters}"
    end

    raise
  end
end

private

def check_validity(attempt)
  attempt.chars.all? { |char| @letters.include?(char.upcase) }
end

def check_letter_overuse(attempt)
  attempt.chars.all? { |char| attempt.count(char) <= @letters.count(char.upcase) }
end

# { time: end_time - start_time,
#   score: dictionary_json["found"] && valid && letter_overuse ? (((end_time - start_time) * -1) + dictionary_json["length"]) : 0,
#   message: dictionary_json["found"] && valid && letter_overuse ? "Well done!" : "Your word was not valid, #{invalid_message}" }
