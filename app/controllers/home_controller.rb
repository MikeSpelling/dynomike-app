class HomeController < ApplicationController

  caches_page :index
  before_filter :authenticate, :except => [:index, :comment]

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == "admin" && password == Password.all[0][:text]
    end
  end

  def index
    @comments = Comment.all
    @comments.select!{|comment| comment.blog_id == nil}

    num_comments = 20
    num_comments = @comments.size if num_comments > @comments.size
    @comments = @comments.reverse[0..num_comments-1] unless @comments.nil?
  end

  def comment
    @comment = Comment.new(params[:post])
    @comment.save

    expire_page :action => :index
    redirect_to :action => 'index'
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    @comment = Comment.all

    expire_page :action => :index
    redirect_to :action => 'index'
  end

end
