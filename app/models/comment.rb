class Comment < ActiveRecord::Base

  belongs_to :commenter, class_name: "User"
  belongs_to :story

  validates :text, presence: true, length: { minimum: 1}

  private

end
