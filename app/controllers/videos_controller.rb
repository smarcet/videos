class VideosController < ApplicationController

  def initialize
    super
    @api = ::Services::ZypeApi.new
  end

  def index
    page = params[:page] ||= 1
    response = @api.get_videos(page.to_i, 12)
    @videos = response['response']
    @pagination = response['pagination']
  end

  def play
    video_id = params[:id]
    response = @api.get_video(video_id)
    @video = response['response']
    if @video['subscription_required']
      if current_user.nil?
        redirect_to new_user_session_path(:back_url => video_play_path(video_id)) and return
      end
      response = @api.is_entitled(current_user, video_id)
      if response['message'] == 'entitled'
        render "play_paid_video" and return
      end
      render 'permission_required' and return
    end
    render 'play_free_video'
  end

end
