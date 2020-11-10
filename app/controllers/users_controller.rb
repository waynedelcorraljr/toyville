class UsersController < ApplicationController

    get '/signup' do
        # binding.pry
        if is_logged_in?(session)
            redirect "/users/#{current_user.slug}"
        end
        erb :'/users/signup' 
    end

    get '/login' do
    #    session.clear
        if is_logged_in?(session)
            redirect "/users/#{current_user.slug}"
        end
        erb :'/users/login'
    end

    get '/logout' do
        session.clear
        redirect '/'
    end

    get '/users/:slug' do
        if is_logged_in?(session)
            @user = current_user
            # binding.pry
            erb :'/users/show'
        else
            redirect '/login'
        end
    end

    post '/signup' do
        if User.all.map{|u| u.username}.include?(params[:username])
            redirect '/signup'
        end
        user = User.create(name: params[:name], username: params[:username], password: params[:password])
        session[:user_id] = user.id
        redirect "/users/#{user.slug}"
    end

    post '/login' do
        @user = User.find_by(username: params[:username])
        if @user && @user.authenticate(params[:password]) 
            session[:user_id] = @user.id
            redirect "/users/#{@user.slug}"
        else
            redirect "/login"
        end
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