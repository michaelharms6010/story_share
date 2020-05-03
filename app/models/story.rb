class Story < ActiveRecord::Base

  belongs_to :user
  belongs_to :topic

  default_scope -> { order(created_at: :desc) }
  validates :text, presence: true, length: { minimum: 1}

  validates_uniqueness_of :topic_id, :scope => :user_id

  def html_text
    "<p>" + self.text.split("\n").join("</p><p>") + "</p>"
  end

  def friends_answered(user, topic_id)
    Story.where(topic_id: topic_id, user_id: user.friendships.where(accepted: true).select(:friend_id)).count
  end

end
