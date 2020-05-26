class Comment < ActiveRecord::Base

  belongs_to :user
  belongs_to :story

  validates :text, presence: true, length: { minimum: 1}

  after_create :create_notification

  def self.visibility_options
    # [["Public", 0], ["Friends Only", 1], ["Private", 2]]
    [["Public", 0], ["Private", 2]]
  end

  # TODO: Move this into a helper (repeated in story.rb)
  def html_text
    "<p class='story-comment-text'>" + self.text.split("\n").join("</p><p class='story-comment-text'>") + "</p>"
  end

  def create_notification
    Notification.create(record_type: "comment", record_id: self.id, user_id: self.story.user_id)
  end

end
