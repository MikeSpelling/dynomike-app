class HomeController < ApplicationController

  before_filter :authenticate, :except => [:index, :comment]

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == "admin" && password == Password.all[0][:text]
    end
  end

  def index
    @comments = Comment.all
  end

  def comment
    @comment = Comment.new(params[:post])
    @comment.save
    @comments = Comment.all

    render :action => 'index'
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    @comment = Comment.all

    redirect_to :action => 'index'
  end

end
