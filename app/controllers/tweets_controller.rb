class TweetsController < ApplicationController

    get '/tweets' do
        if logged_in?
            @tweets = Tweet.all
            erb :'tweets/index'
        else
            redirect to :'users/login'
        end
    end

    get '/tweets/new' do
        if logged_in?
            erb :'tweets/new'
        else
            redirect to '/login'
        end
    end

    get '/tweets/:id' do
        if logged_in?
            @tweet = Tweet.find_by(id: params[:id])
            erb :'tweets/show'
        else
            redirect to '/login'
        end
    end

    post '/tweets' do
        if logged_in? && !params[:content].empty?
            @tweet = Tweet.create(content: params[:content], user_id: session[:user_id])
            redirect to "/tweets/#{@tweet.id}"
        else
            redirect to "/tweets/new"
        end    
    end

    get '/tweets/:id/edit' do
        @tweet = Tweet.find_by(id: params[:id])
        if logged_in? && @tweet.user_id == session[:user_id]
            erb :'/tweets/edit'
        else
            redirect to '/login'
        end
    end

    patch '/tweets/:id' do
        @tweet = Tweet.find_by(id: params[:id])
        if logged_in? && @tweet.user_id == session[:user_id] 
            if params[:content] != ""
                @tweet.update(content: params[:content])
                redirect to "/tweets/#{@tweet.id}"
            else
                redirect to "/tweets/#{@tweet.id}/edit"
            end
        else
            redirect to '/login'
        end
    end

    delete '/tweets/:id/delete' do
        @tweet = Tweet.find_by(id: params[:id])
        if logged_in? && @tweet.user_id == session[:user_id]
            @tweet.delete
        else
            redirect to '/login'
        end
    end

end
