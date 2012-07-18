class BlogController < ApplicationController
  def index
    @blogs = Blog.all
  end

  def post
    password = params[:post][:password]
    expected_password = Password.all[0][:text]
    if password == expected_password
      blog_post = {:title => params[:post][:title], :text => params[:post][:text]}
      @blog = Blog.new(blog_post)
      @blog.save
    end
    @blogs = Blog.all

    render :action => 'index'
  end

  def destroy
    @blog = Blog.find(params[:id])
    @blog.destroy
    @blogs = Blog.all

    redirect_to :action => 'index'
  end
end
