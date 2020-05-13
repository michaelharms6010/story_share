class Story < ActiveRecord::Base

  belongs_to :user
  belongs_to :topic

  has_many :comments, dependent: :destroy

  default_scope -> { order(created_at: :desc) }
  validates :text, presence: true, length: { minimum: 1}

  validates_uniqueness_of :topic_id, :scope => :user_id

  # TODO: Move this into a helper (repeated in comment.rb)
  def html_text
    "<p>" + self.text.split("\n").join("</p><p>") + "</p>"
  end

  def friends_answered(user, topic_id)
    Story.where(topic_id: topic_id, user_id: user.friendships.where(accepted: true).select(:friend_id)).count
  end

  def comments_viewable_by(user)
    if self.user == user
      Comment.where(story: self)
    else
      Comment.where(story: self, visibility: 0)
    end
  end

end
