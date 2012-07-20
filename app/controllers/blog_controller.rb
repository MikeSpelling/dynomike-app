class BlogController < ApplicationController

  caches_page :index, :by_id
  before_filter :authenticate, :except => [:index]

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == "admin" && password == Password.all[0][:text]
    end
  end

  def index
    @blogs = Blog.all
  end

  def individual_blog
    @blog = Blog.find(params[:id])
  end

  def edit_blog
    @blog = Blog.find(params[:id])
  end

  def post_edit
    @blog = Blog.find(params[:id])

    if @blog.update_attributes(params[:post])
      redirect_to :action => :individual_blog, :id => @blog.id
    else
      render 'edit_blog'
    end
  end

  def post
    blog_post = {:title => params[:post][:title], :text => params[:post][:text]}
    @blog = Blog.new(blog_post)
    @blog.save
    @blogs = Blog.all

    expire_page :action => :index
    render :action => 'index'
  end

  def destroy
    @blog = Blog.find(params[:id])
    @blog.destroy
    @blogs = Blog.all

    expire_page :action => :index
    redirect_to :action => 'index'
  end

end
