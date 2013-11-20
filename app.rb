require 'bundler/setup'

require 'sinatra'
require 'haml'
require 'sinatra/activerecord'

require 'rack-flash'
require 'bcrypt'

configure(:development){ set :database, 'sqlite3:///twitter.sqlite3' }

require './models'

#stuff you need for the flash
enable :sessions
use Rack::Flash, :sweep => true
set :sessions => true

helpers do
  def current_user
    if session[:user_id]
      User.find(session[:user_id])
    else
      nil
    end
  end
end

def current_user
  if session[:user_id]
    User.find(session[:user_id])
  else
    nil
  end
end



get '/' do
  @users = User.all
  @tweets = Tweet.all
  haml :home
end

get '/users/new' do
  haml :new_user
end

post '/users/new' do
  @user = User.new(params['user'])
  if @user.save
    flash[:notice] = "You have signed up successfully."
    redirect '/'
  else
    flash[:alert] = "There was a problem signing you up."
    redirect '/users/new'
  end
end

get '/users/:id' do
  @user = User.find(params[:id])
  haml :profile
end

get '/sign_in' do
  haml :sign_in
end

post '/sign_in' do
  @user = User.authenticate(params['user']['email'], params['user']['password'])
  if @user
    session[:user_id] = @user.id
    flash[:notice] = "You've signed in successfully."
    redirect '/'
  else
    flash[:alert] = "There was a problem signing you in."
    redirect '/sign_in'
  end
end

get '/sign_out' do
  session[:user_id] = nil
  flash[:notice] = "You've been signed out."
  redirect '/'
end

post '/tweets/new' do
  if current_user
    @tweet = Tweet.new(text: params['text'], created_at: Time.now, user_id: current_user.id)
    if @tweet.save
      flash[:notice] = "Your tweet was saved successfully."
    else
      flash[:alert] = "There was a problem saving your tweet."
    end
    redirect "/users/#{current_user.id}"
  end
end



