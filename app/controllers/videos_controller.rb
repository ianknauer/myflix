class VideosController < ApplicationController
  before_filter :require_user
  before_action :set_video, only: [:show]
  
  def index
    @videos = Video.all
    @categories = Category.all
  end
  
  def show
  end
  
  def search
    @results = Video.search_by_title(params[:search_term])
  end
  
  private
  
  def set_video
     @video = Video.find_by_id(params[:id])
  end
  
end