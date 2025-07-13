require 'sinatra/base'
require 'sinatra/flash'
require_relative 'lib/wordguesser_game'

class WordGuesserApp < Sinatra::Base
  enable :sessions
  register Sinatra::Flash

  set :host_authorization, { permitted_hosts: [] }  

  before do
    @game = session[:game] || WordGuesserGame.new('')
  end

  after do
    session[:game] = @game
  end

  get '/' do
    redirect '/new'
  end

  get '/new' do
    erb :new
  end

  post '/create' do
    # NOTE: don't change next line - it's needed by autograder!
    word = params[:word] || WordGuesserGame.get_random_word
    # NOTE: don't change previous line - it's needed by autograder!

    @game = WordGuesserGame.new(word)
    redirect '/show'
  end

  post '/guess' do
    letter = params[:guess].to_s[0] || ''

    if letter.empty? || letter !~ /[a-zA-Z]/
      flash[:message] = "Invalid guess."
    elsif !@game.guess(letter)
      flash[:message] = "You have already used that letter."
    end

    redirect '/show'
  end

  get '/show' do
    case @game.check_win_or_lose
    when :win
      redirect '/win'
    when :lose
      redirect '/lose'
    else
      erb :show
    end
  end

  get '/win' do
    redirect '/show' unless @game.check_win_or_lose == :win
    erb :win
  end

  get '/lose' do
    redirect '/show' unless @game.check_win_or_lose == :lose
    erb :lose
  end
end