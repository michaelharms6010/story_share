class Comment < ActiveRecord::Base

  belongs_to :user
  belongs_to :story

  validates :text, presence: true, length: { minimum: 1}

  private

end
