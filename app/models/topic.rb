class Topic < ActiveRecord::Base

  default_scope -> { order(published_at: :desc) }
  validates :text, presence: true
  validates :prompt, presence: true, length: { minimum: 10, maximum: 255 },
                    uniqueness: { case_sensitive: false }

  def length_options
    ["MICRO", "SHORT", "MEDIUM", "LONG"]
  end

  private

end