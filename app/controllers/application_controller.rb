require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    enable :sessions
    set :session_secret, "password_security"
    set :views, 'app/views'
  end

  get "/" do
    erb :home
  end

end
