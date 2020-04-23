class Topic < ActiveRecord::Base

  has_many   :stories, dependent: :destroy

  validates :prompt, presence: true, length: { minimum: 10, maximum: 255 },
                    uniqueness: { case_sensitive: false }
  validates :length, presence: true

  def self.length_options
    ["MICRO", "SHORT", "MEDIUM", "LONG"]
  end

  def write_time
    if self.length == "MICRO"
      1.minute
    elsif self.length == "SHORT"
      3.minutes
    elsif self.length == "MEDIUM"
      5.minutes
    elsif self.length == "LONG"
      7.minutes
    else
      5.minutes
    end
  end

  private

end