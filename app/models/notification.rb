class Notification < ActiveRecord::Base

  belongs_to :user
  belongs_to :comment

end
