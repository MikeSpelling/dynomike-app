class WeatherController < ApplicationController

  def index
    @ip = request.remote_ip
    weather_xml = `curl -s "http://free.worldweatheronline.com/feed/weather.ashx?key=9d38708210104504120808&includeLocation=yes&q=#{@ip}"`

    @location = `echo "#{weather_xml}" | grep -o "<areaName>.*</areaName>" | cut -c 20- | sed 's/..............$//'`
    @temp = `echo "#{weather_xml}" | grep -o "<temp_C>.*</temp_C>" | cut -c 9- | sed 's/.........$//'`
    @windSpeed = `echo "#{weather_xml}" | grep -o "<current_condition>.*</current_condition>" | grep -o "<windspeedMiles>.*</windspeedMiles>" | cut -c 17- | sed 's/.................$//'`
    @windDirection = `echo "#{weather_xml}" | grep -o "<current_condition>.*</current_condition>" | grep -o "<winddir16Point>.*</winddir16Point>" | cut -c 18- | sed 's/..................$//'`
    @maxTemp = `echo "#{weather_xml}" | grep -o "<tempMaxC>.*</tempMaxC>" | cut -c 11- | sed 's/...........$//'`
    @minTemp = `echo "#{weather_xml}" | grep -o "<tempMinC>.*</tempMinC>" | cut -c 11- | sed 's/...........$//'`
    @weatherDesc = `echo "#{weather_xml}" | grep -o "<current_condition>.*</current_condition>" | grep -o "<weatherDesc>.*</weatherDesc>" | cut -c 23- | sed 's/.................$//'`
    @weatherImgSrc = `echo "#{weather_xml}" | grep -o "<current_condition>.*</current_condition>" | grep -o "<weatherIconUrl>.*</weatherIconUrl>" | cut -c 26- | sed 's/....................$//'`
    @precipitation = `echo "#{weather_xml}" | grep -o "<current_condition>.*</current_condition>" | grep -o "<precipMM>.*</precipMM>" | cut -c 11- | sed 's/...........$//'`
    @cloudCover = `echo "#{weather_xml}" | grep -o "<current_condition>.*</current_condition>" | grep -o "<cloudcover>.*</cloudcover>" | cut -c 13- | sed 's/.............$//'`

  end

end
