class ToysController < ApplicationController

    get '/toys/new' do
        binding.pry
        if is_logged_in?(session)
            erb :'/toys/new'
        end
        redirect '/login'
    end
    
    get '/toys/:id' do
        @toy = Toy.find(params[:id])
        erb :'/toys/show'
    end

    post '/toys/new' do
        toy = Toy.create(name: params[:name], category: params[:category], user_id: current_user.id)
        redirect "/toys/#{toy.id}"
    end

    helpers do
        def is_logged_in?(session)
          !!session[:user_id]
        end
    
        def current_user
          User.find(session[:user_id])
        end
    end

end