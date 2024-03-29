class Friendship < ActiveRecord::Base

  belongs_to :user
  belongs_to :friend, class_name: "User"

  validates_uniqueness_of :user_id, :scope => :friend_id
  validate :not_friends_with_self

  before_save :set_confirmation

  def self.create_bidirectional_friendship(user_id, friend_id)
    if Friendship.create(user_id: user_id, friend_id: friend_id, confirmed: true)
      Friendship.create(user_id: friend_id, friend_id: user_id, accepted: true)
    end
  end

  def self.create_and_confirm_bidirectional_friendship(user_id, friend_id)
    if Friendship.create(user_id: user_id, friend_id: friend_id, confirmed: true, accepted: true)
      Friendship.create(user_id: friend_id, friend_id: user_id, confirmed: true, accepted: true)
    end
  end

  def friends?
    self.confirmed && self.accepted && self.inverse_friendship.confirmed && self.inverse_friendship.accepted
  end

  def inverse_friendship
    Friendship.find_by(user_id: self.friend_id, friend_id: self.user_id)
  end

  def accept_friendship
    if self.update(confirmed: true, rejected: false, accepted: true)
      self.inverse_friendship.update(accepted: true)
    end
  end

  def reject_friendship
    if self.update(confirmed: true, rejected: true, accepted: false)
      self.inverse_friendship.update(accepted: false)
    end
  end

  private

  def not_friends_with_self
    errors.add(:user_id, "can't be friends with self") if user_id == friend_id
  end

  def set_confirmation
    self.confirmed_at = confirmed ? DateTime.now : nil if confirmed_changed? || rejected_changed?
  end
end
