class Comment < ActiveRecord::Base

  belongs_to :user
  belongs_to :story

  validates :text, presence: true, length: { minimum: 1}

  def self.visibility_options
    [["Public", 0], ["Friends Only", 1], ["Private", 2]]
  end

  # TODO: Move this into a helper (repeated in story.rb)
  def html_text
    "<p>" + self.text.split("\n").join("</p><p>") + "</p>"
  end

end
