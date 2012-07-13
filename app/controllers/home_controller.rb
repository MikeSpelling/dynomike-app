class HomeController < ApplicationController
  def index
    @comments = Comment.all
  end

  def comment
    @comment = Comment.new(params[:post])
    @comment.save
    @comments = Comment.all

    render :action => 'index'
  end
end
