class Admin::VideosController < AdminsController
  before_action :require_user
  before_action :require_admin
  
  def new
    @video = Video.new
  end
  
  def create
    @video = Video.new(video_params)
    if @video.save
      flash[:success] = "You have successfully added the video '#{@video.name}'."
      redirect_to new_admin_video_path
    else
      flash[:error] = "Something went wrong with your submission"
      render :new
    end
  end
  
  def video_params
    params.require(:video).permit(:name, :description, :category_id, :large_thumb, :small_thumb, :video_url)
  end 
end
