
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
            flash[:message] = "You must be logged in to view user's page."
            redirect '/login'
        end
    end

    get '/users/:slug/edit' do
        if is_logged_in?(session)
            @user = current_user
            erb :'/users/edit'
        else
            redirect '/login'
        end
    end

    post '/signup' do
        if User.all.map{|u| u.username}.include?(params[:username])
            flash[:message] = "That username already exists, please try again with a different username."
            redirect '/signup'
        end
        if !params[:username].empty? && !params[:password].empty?
        user = User.create(name: params[:name], username: params[:username], password: params[:password])
        session[:user_id] = user.id
        redirect "/users/#{user.slug}"
        else
            redirect '/signup'
        end
    end

    post '/login' do
        @user = User.find_by(username: params[:username])
        if @user && @user.authenticate(params[:password]) 
            session[:user_id] = @user.id
            redirect "/users/#{@user.slug}"
        else
            flash[:message] = "username or password not found"
            redirect "/login"
        end
    end

    patch '/users/:slug' do
        @user = current_user
        if @user && !params[:name].empty?
            @user.update(name: params[:name])
            redirect "/users/#{@user.slug}"
        end
        flash[:message] = "You cannot edit other user's information."
        redirect '/login'
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