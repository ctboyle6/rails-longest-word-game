require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    alphabet = ('A'..'Z').to_a
    @letters = []

    10.times do
      @letters << alphabet.sample
    end

    @letters
  end

  def score
    @attempt = params[:answer]
    @letters = params[:letters]
    dictionary_json = call_dictionary
    @response = ''
    @score = 0

    if check_validity? && check_letter_overuse? && dictionary_json['found'] == true
      @response = "Congrats! #{@attempt} is an English word!"
      @score = dictionary_json['length'] * 1000
    else
      @response = dictionary_json['found'] == false ? 'not an English word!' : "cannot be built out of #{@letters}"
    end

    raise
  end
end

private

def call_dictionary
  url = "https://wagon-dictionary.herokuapp.com/#{@attempt}"
  dictionary_serial = open(url).read
  JSON.parse(dictionary_serial)
end

def check_validity?
  @attempt.chars.all? { |char| @letters.include?(char.upcase) }
end

def check_letter_overuse?
  @attempt.chars.all? { |char| @attempt.count(char) <= @letters.count(char.upcase) }
end

# { time: end_time - start_time,
#   score: dictionary_json["found"] && valid && letter_overuse ? (((end_time - start_time) * -1) + dictionary_json["length"]) : 0,
#   message: dictionary_json["found"] && valid && letter_overuse ? "Well done!" : "Your word was not valid, #{invalid_message}" }
