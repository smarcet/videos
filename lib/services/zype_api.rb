
require 'uri'
require 'net/http'
require 'json'

module Services
  class ZypeApi
    BASE_URL = 'https://api.zype.com'

    def get_videos(page=1, per_page=10)
      response = Rails.cache.fetch("#{page}_#{per_page}/videos", expires_in: 1.hours) do
        url = URI("#{ZypeApi::BASE_URL}/videos?app_key=#{ENV['APP_KEY']}&page=#{page}&per_page=#{per_page}&sort=created_at&order=desc")
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        request = Net::HTTP::Get.new(url)
        response = http.request(request)
        response.read_body.to_s
      end
      JSON.parse(response)
    end

    def get_video(id)
      response = Rails.cache.fetch("videos/#{id}", expires_in: 1.hours) do
        url = URI("#{ZypeApi::BASE_URL}/videos/#{id}?app_key=#{ENV['APP_KEY']}")
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        request = Net::HTTP::Get.new(url)
        response = http.request(request)
        response.read_body.to_s
      end
      JSON.parse(response)
    end

    def auth(user_name, password)
      url = URI("https://login.zype.com/oauth/token?client_id=#{ENV['OAUTH2_CLIENT_ID']}&client_secret=#{ENV['OAUTH2_CLIENT_SECRET']}&username=#{user_name}&grant_type=password&password=#{password}")
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      request = Net::HTTP::Post.new(url)
      response = http.request(request)
      JSON.parse(response.read_body.to_s)
    end

    def is_entitled(user, video_id)
      access_token = user.access_token
      url = URI("https://api.zype.com/videos/#{video_id}/entitled?access_token=#{access_token}")
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      request = Net::HTTP::Get.new(url)
      response = http.request(request)
      JSON.parse(response.read_body.to_s)
    end

  end
end