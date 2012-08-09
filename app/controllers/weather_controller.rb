class WeatherController < ApplicationController

  require 'rubygems'
  require 'nokogiri'

  def index
    @ip = request.remote_ip
    weather_xml = Nokogiri::XML(`curl -s "http://free.worldweatheronline.com/feed/weather.ashx?key=9d38708210104504120808&includeLocation=yes&q=#{@ip}"`)

    @location = weather_xml.xpath("//data/nearest_area/areaName").text
    @temp = weather_xml.xpath("//data/current_condition/temp_C").text
    @windSpeed = weather_xml.xpath("//data/current_condition/windspeedMiles").text
    @windDirection = weather_xml.xpath("//data/current_condition/winddir16Point").text
    @weatherDesc = weather_xml.xpath("//data/weather/tempMinC").text
    @weatherImgSrc = weather_xml.xpath("//data/current_condition/weatherIconUrl").text
    @precipitation = weather_xml.xpath("//data/current_condition/precipMM").text
    @cloudCover = weather_xml.xpath("//data/current_condition/cloudcover").text
    @maxTemp = weather_xml.xpath("//data/weather/tempMaxC").text
    @minTemp = weather_xml.xpath("//data/weather/tempMinC").text
  end

end
