class WordGuesserGame
  attr_accessor :word, :guesses, :wrong_guesses

  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  def guess(letter)
    raise ArgumentError if letter.nil? || letter.empty? || letter =~ /[^a-zA-Z]/
    letter = letter.downcase
    return false if @guesses.include?(letter) || @wrong_guesses.include?(letter)
    @word.include?(letter) ? @guesses += letter : @wrong_guesses += letter
    true
  end

  def word_with_guesses
    @word.chars.map { |c| @guesses.include?(c) ? c : '-' }.join
  end

  def check_win_or_lose
    return :win if word_with_guesses == @word
    return :lose if @wrong_guesses.length >= 7
    :play
  end

  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start { |http| return http.post(uri, "").body }
  end
end