class Topic < ActiveRecord::Base

  validates :text, presence: true
  validates :prompt, presence: true, length: { minimum: 10, maximum: 255 },
                    uniqueness: { case_sensitive: false }

  def self.length_options
    ["MICRO", "SHORT", "MEDIUM", "LONG"]
  end

  private

end