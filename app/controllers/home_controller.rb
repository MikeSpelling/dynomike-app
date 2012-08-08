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

    @ip = request.remote_ip
    
    weather_xml = `curl -s "http://free.worldweatheronline.com/feed/weather.ashx?key=9d38708210104504120808&includeLocation=yes&q=#{@ip}"`
    @location = `echo "#{weather_xml}" | grep -o "<areaName>.*</areaName>" | cut -c 20- | sed 's/..............$//'`
    @temp = `echo "#{weather_xml}" | grep -o "<temp_C>.*</temp_C>" | cut -c 9- | sed 's/.........$//'`
    @windSpeed = `echo "#{weather_xml}" | grep -o "<current_condition>.*</current_condition>" | grep -o "<windspeedMiles>.*</windspeedMiles>" | cut -c 16- | sed 's/................$//'`
    @windDirection = `echo "#{weather_xml}" | grep -o "<current_condition>.*</current_condition>" | grep -o "<winddir16Point>.*</winddir16Point>" | cut -c 17- | sed 's/.................$//'`
    @maxTemp = `echo "#{weather_xml}" | grep -o "<tempMaxC>.*</tempMaxC>" | cut -c 11- | sed 's/...........$//'`
    @minTemp = `echo "#{weather_xml}" | grep -o "<tempMinC>.*</tempMinC>" | cut -c 11- | sed 's/...........$//'`
    `echo "#{weather_xml}" | grep -o "<current_condition>.*</current_condition>" | grep -o "<weatherIconUrl>.*</weatherIconUrl>" | cut -c 26- | sed 's/....................$//' | xargs curl -s -o weather.png`

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
