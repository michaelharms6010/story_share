class Story < ActiveRecord::Base

  belongs_to :user
  belongs_to :topic

  default_scope -> { order(created_at: :desc) }
  validates :text, presence: true

  def html_text
    self.text.gsub("\n", "</br>")
    "<p>" + self.text.split("\n").join("</p><p>") + "</p>"
  end

end
