class ToysController < ApplicationController

    get '/toys/new' do
        # binding.pry
        if !is_logged_in?
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
        if is_logged_in? && current_user.id == @toy.user_id
            erb :'/toys/edit'
        else
            flash[:message] = "You cannot edit other user's toys."
            redirect '/login'
        end
    end

    post '/toys' do
        toy = Toy.create(name: params[:name], category: params[:category], user_id: current_user.id)
        if toy.valid?
            redirect "/toys/#{toy.id}"
        else
            flash[:message] = "No blank entry allowed."
            redirect '/toys/new'
        end
        
    end

    patch '/toys/:id' do 
        toy = Toy.find(params[:id])
        if current_user.id == toy.user_id
            toy.update(name: params[:name], category: params[:category])
            redirect "/toys/#{toy.id}"
        else
            flash[:message] = "You cannot edit other user's toys."
            redirect "/toys/#{toy.id}"
        end
    end

    delete '/toys/:id' do
        toy = Toy.find(params[:id])
        if is_logged_in? && toy.user_id == session[:user_id]
            toy.delete
        end
        redirect "/users/#{current_user.slug}"
    end

end