class ToysController < ApplicationController

    get '/toys/new' do
        # binding.pry
        if !is_logged_in?(session)
            redirect '/login'
        end
        erb :'/toys/new'
    end
    
    get '/toys/:id' do
        @toy = Toy.find(params[:id])
        erb :'/toys/show'
    end

    get '/toys/:id/edit' do
        @toy = Toy.find(params[:id])
        if is_logged_in?(session) && current_user.id == @toy.user_id
            erb :'/toys/edit'
        else
            flash[:message] = "You cannot edit other user's toys."
            redirect '/login'
        end
    end

    post '/toys/new' do
        if !params[:name].empty? && !params[:category].empty?
            # user = current_user
            # toy = user.toys.build(name: params[:name], category: params[:category])
            # binding.pry
            toy = Toy.create(name: params[:name], category: params[:category], user_id: current_user.id)
            redirect "/toys/#{toy.id}"
        else
            flash[:message] = "No blank entry allowed."
            redirect '/toys/new'
        end
        
    end

    patch '/toys/:id' do 
        toy = Toy.find(params[:id])
        if !params[:name].empty? && !params[:category].empty? && current_user.id == toy.user_id
            toy.update(name: params[:name], category: params[:category])
            redirect "/toys/#{toy.id}"
        else
            redirect "/toys/#{toy.id}/edit"
        end
    end

    delete '/toys/:id' do
        toy = Toy.find(params[:id])
        if is_logged_in?(session) && toy.user_id == session[:user_id]
            toy.delete
        end
        redirect "/users/#{current_user.slug}"
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