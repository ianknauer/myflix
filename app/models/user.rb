class User < ActiveRecord::Base
  include Tokenable #hides user id from user

  has_secure_password validations: false
  has_many :queue_items, -> { order('position') } #order queue_items by position
  has_many :reviews, -> { order('created_at DESC') } #order reviews by descending created at
  has_many :following_relationships, class_name: "Relationship", foreign_key: :follower_id #people that this user is following
  has_many :leading_relationships, class_name: "Relationship", foreign_key: :leader_id #people that are following this user
  validates :email, presence: true #requires email
  validates :full_name, presence: true #requires full_name
  validates :password, presence: true, on: :create #requires password on create only

  def normalize_queue_item_positions #makes sure we don't acccidently end up with something in queue position of 0
    queue_items.each_with_index do |queue_item, index|
      queue_item.update_attributes(position: index+1)
    end
  end

  def queued_video?(video) #checks if a video is queued by this person
    queue_items.map(&:video).include?(video)
  end

  def follows?(another_user) #checks if they follow a user
    following_relationships.map(&:leader).include?(another_user)
  end

  def follow(another_user) #adds a following user relationship if it can
    following_relationships.create(leader: another_user) if can_follow?(another_user)
  end


  def can_follow?(another_user) #checks whether they already follow, or are trying to follow themselves
    !(self.follows?(another_user) || self == another_user)
  end

  def deactivate! #deactivates user, used when they don't pay
    update_column(:active, false)
  end
end
