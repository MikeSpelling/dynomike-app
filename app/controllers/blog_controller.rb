class BlogController < ApplicationController

  caches_page :index, :individual_blog
  before_filter :authenticate, :except => [:index, :individual_blog, :post_comment]

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == "admin" && password == Password.all[0][:text]
    end
  end

  def index
    @blogs = Blog.all
    @blogs.sort! { |x, y| y.updated_at <=> x.updated_at }
  end

  def individual_blog
    id = params[:id_title].split("-")[0]
    @blogs = Blog.all
    @blogs.sort! { |x, y| y.updated_at <=> x.updated_at }
    @blog = Blog.find(id)

    @comments = Comment.all
    @comments.select! { |comment| comment.blog_id == @blog.id }

    num_comments = 20
    num_comments = @comments.size if num_comments > @comments.size
    @comments = @comments.reverse[0..num_comments-1] unless @comments.nil?

    @error = params[:error]
    if @error
      @comment_author = params[:author]
      @comment_text = params[:text]
    end
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
      expire_page :action => :individual_blog, :id_title => "#{@blog.id}-#{@blog.title}"
      redirect_to :action => :individual_blog, :id_title => "#{@blog.id}-#{@blog.title}"
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
    title = @blog.title
    @blog.destroy
    @blogs = Blog.all

    expire_page :action => :index
    expire_page :action => :individual_blog, :id_title => "#{params[:id]}-#{title}"
    redirect_to :action => 'index'
  end

  def post_comment
    @blog = Blog.find(params[:id])
    title = @blog.title
    @comment = Comment.new(params[:post])
    @comment.save

    if @comment.errors.any?
      redirect_to :action => :individual_blog, :id => "#{params[:id]}-#{title}", :error => @comment.errors.full_messages.first, :author => params[:post][:author], :text => params[:post][:text]
    else
      expire_page :action => :individual_blog, :id_title => "#{params[:id]}-#{title}"
      redirect_to :action => :individual_blog, :id_title => "#{params[:id]}-#{title}"
    end
  end

  def destroy_comment
    @comment = Comment.find(params[:comment_id])
    @comment.destroy
    @comment = Comment.all

    @blog = Blog.find(params[:blog_id])
    title = @blog.title

    expire_page :action => :individual_blog, :id_title => "#{params[:blog_id]}-#{title}"
    redirect_to :action => :individual_blog, :id_title => "#{params[:blog_id]}-#{title}"
  end

end
