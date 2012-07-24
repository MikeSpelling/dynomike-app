class BlogController < ApplicationController

  caches_page :index, :individual_blog
  before_filter :authenticate, :except => [:index, :individual_blog]

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == "admin" && password == Password.all[0][:text]
    end
  end

  def index
    @blogs = Blog.all
    @blogs.sort!{|x,y| y.updated_at <=> x.updated_at }
  end

  def individual_blog
    @blog = Blog.find(params[:id])
  end

  def edit_blog
    @id = params[:id]
    @error = params[:error]
    if @error
      @title = params[:title]
      @text = params[:text]
    else
      blog = Blog.find(params[:id])
      @title = blog.title
      @text = blog.text
    end
  end

  def post_edit
    @blog = Blog.find(params[:id])

    @blog.update_attributes(params[:post])
    if @blog.errors.any?
      redirect_to :action => :edit_blog, :id => @blog.id, :error => @blog.errors.full_messages.first, :title => params[:post][:title], :text => params[:post][:text]
    else
      expire_page :action => :index
      expire_page :action => :individual_blog, :id => @blog.id
      redirect_to :action => :individual_blog, :id => @blog.id
    end
  end

  def new_blog
    blog_post = {:title => "Blog title", :text => "Enter blog here..."}
    @blog = Blog.new(blog_post)
    @blog.save

    expire_page :action => :index
    redirect_to :action => :edit_blog, :id => @blog.id
  end

  def destroy
    @blog = Blog.find(params[:id])
    @blog.destroy
    @blogs = Blog.all

    expire_page :action => :index
    expire_page :action => :individual_blog, :id => params[:id]
    redirect_to :action => 'index'
  end

end
