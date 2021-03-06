class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews, -> { order('created_at DESC') }
  validates :name, presence: true
  validates :description, presence: true
  
  mount_uploader :large_thumb, LargeThumbUploader
  mount_uploader :small_thumb, SmallThumbUploader
  
  def self.search_by_title(search_term)
    return [] if search_term.blank?
    where("name LIKE ?",  "%#{search_term}%").order("created_at DESC")
  end

  def rating
    reviews.average(:rating).round(1) if reviews.average(:rating)
  end
end 