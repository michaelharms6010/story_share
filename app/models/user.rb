class User < ApplicationRecord

  has_many :comments  # Keep comments, even if user is destroyed
  has_many :notifications, dependent: :destroy
  has_many :stories, dependent: :destroy
  has_many :friendships, dependent: :destroy

  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id", dependent: :destroy

  attr_accessor :remember_token, :activation_token, :reset_token

  validates :name,  presence: true, length: { maximum: 20 , minimum: 3},
                    uniqueness: { case_sensitive: false }, allow_nil: true
  validates_format_of :name, :with => /\A[a-zA-Z\d]*\z/i,
  :message => "can only contain letters and numbers."
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  before_save   :downcase_email
  before_save   :downcase_name
  before_create :create_activation_digest

  # Returns the hash digest of the given string.
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def self.is_email(test_string)
    !!VALID_EMAIL_REGEX.match(test_string)
  end

  def topics_answered
    self.stories.select(:topic_id)
  end

  # Show stories that have been also answered by a given friend
  def friend_stories(friend)
    self.stories.where(topic_id: friend.topics_answered)
  end

  # Return the number of friends who have completed a given topic and the first five names
  def friends_completed_topic(topic)
    stories = Story.where(topic: topic, user: self.friends)
    count = stories.count
    names = stories.limit(5).joins(:user).select("users.name_formatted").map{|x| x.attributes["name_formatted"]}
    # names = ["a", "b", "c", "d", "e"]
    names.append("more") if names.length > count
    {count: count, names: names}
    if count == 0
      "You are the first of your friends to write this story!"
    elsif count == 1 && names.length == 1
      "#{names[0]} has responded to this prompt."
    else
      "#{count} of your friends have completed this story: #{names.to_sentence({last_word_connector: ' and '})}. Post yours to see theirs!"
    end
  end

  def unread_notifications
    self.notifications.order("id DESC").where(viewed: false)
  end

  def notification_count
    self.unread_notifications.count
  end

  def self.time_zones_for_select
    time_zones = [["American Samoa", "SST"], ["Hawaii", "HST"], ["Alaska", "AKST"], ["Pacific Time (US & Canada)", "PST"], ["Mountain Time (US & Canada)", "MST"], ["Central Time (US & Canada)", "CST"], ["Eastern Time (US & Canada)", "EST"], ["Atlantic Time (Canada)", "AST"], ["Newfoundland", "NST"], ["Buenos Aires", "ART"], ["Mid-Atlantic", "GST"], ["Azores", "AZOT"], ["London", "GMT"], ["Berlin", "CET"], ["Athens", "EET"], ["Moscow", "MSK"], ["Tehran", "IRDT"], ["Samara", "SAMT"], ["Kabul", "AFT"], ["Islamabad", "PKT"], ["Mumbai", "IST"], ["Kathmandu", "NPT"], ["Dhaka", "BST"], ["Bangkok", "ICT"], ["Beijing", "CST"], ["Tokyo", "JST"], ["Adelaide", "ACST"], ["Sydney", "AET"], ["New Caledonia", "NCT"], ["Fiji", "FJT"], ["Chatham Is.", "CHAST"], ["Samoa", "WST"]]
    select_options = {}
    time_zones.each do |zone|
      select_options[Time.now.in_time_zone(zone[0]).strftime("#{zone[1]}: #{zone[0]} - %l:%M %P")] = zone[0]
    end
    select_options
  end

  def display_name
    if self.show_full_name && self.first_name.present? && self.last_name.present?
      "#{self.first_name} #{self.last_name}"
    else
      self.name_formatted
    end
  end

  def story_available
    self.stories_today.length == 0 && self.next_topic.present?
  end

  def time_to_next_story
    if self.story_available
      0
    else
      Time.now.in_time_zone(self.time_zone).end_of_day - Time.now.in_time_zone(self.time_zone)
    end
  end

  def stories_today
    self.stories.where(created_at: Time.now.in_time_zone(self.time_zone).beginning_of_day..Time.now.in_time_zone(self.time_zone).end_of_day)
  end

  def all_stories
    Story.where(user_id: self.friendships.where(accepted: true).select(:friend_id), topic_id: self.topics_answered).or(Story.where(user_id: self.id)).order("updated_at DESC")
  end

  # Get the next topic
  def next_topic
    Topic.where.not(id: self.stories.select(:topic_id)).first
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Activates an account.
  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Sends invite email.
  def send_invite_email(inviter, message)
    UserMailer.account_invite(self, inviter, message).deliver_now
  end

  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def num_friend_requests
    self.friendships.where(confirmed: false, accepted: true).count
  end

  # def add_friend(friend_username)
  #   friend = User.find_by(name: friend_username.downcase)
  #   Friendship.create_bidirectional_friendship(self, friend)
  # end

  def friends
    User.joins(:inverse_friendships).where("friendships.user_id = #{self.id} AND friendships.confirmed = 't' AND friendships.rejected = 'f' AND friendships.accepted = 't'").order("users.name DESC")
  end

  def friends?(friend)
    Friendship.exists?(user: self, friend: friend, accepted: true, confirmed: true) && Friendship.exists?(user: friend, friend: self, accepted: true, confirmed: true)
  end

  # def friend_names_and_ids
  #   BlockGameProfile.where(id: self.friend_block_game_profile_ids).joins(:user)
  #                         .select("users.id", "users.name_formatted").map {|a| a.attributes}
  # end

  # def friendship_requests(page = 1)
  #   self.friendships.where(confirmed: false).paginate(page: page, per_page: 5)
  # end

  # def client_friendship_requests(page = 1)
  #   BlockGameProfile.where(id: self.friendship_request_block_game_profile_ids).joins(:user)
  #                         .select("users.id", "users.name_formatted").map {|a| a.attributes}
  # end

  # def friendship_request_count
  #   self.friendships.where(confirmed: false).count
  # end

  private

    # Converts email to all lower-case.
    def downcase_email
      self.email = email.downcase
    end

    # Converts name to all lower-case but save capitalized name to name_formatted.
    def downcase_name
      if name_changed? && self.name.present?
        self.name_formatted = name
        self.name = name.downcase
      end
    end

    # Creates and assigns the activation token and digest.
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end

end
