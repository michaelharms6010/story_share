class Topic < ActiveRecord::Base

  validates :prompt, presence: true, length: { minimum: 10, maximum: 255 },
                    uniqueness: { case_sensitive: false }
  validates :length, presence: true

  def self.length_options
    ["MICRO", "SHORT", "MEDIUM", "LONG"]
  end

  private

end