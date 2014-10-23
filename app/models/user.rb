class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy
  # connect with relationships by "relationship.follower_id"="user.id"
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  # search in relationships all "followed_id"
  has_many :followed_users, through: :relationships, source: :followed
  # reverse relationship for Relationship model
  has_many :reverse_relationships, class_name: "Relationship", 
    foreign_key: "followed_id", dependent: :destroy
  # search in reverse_relationships all "follower_id"
  has_many :followers, through: :reverse_relationships

	# VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	VALID_EMAIL_REGEX = /\A([\w+]|\b[\-.]{1})+\b@\b([a-z\d]|\b[\-.]{1})+\b[\.]{1}[a-z]+\z/i

	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, 
		uniqueness: { case_sensitive: false }
	validates :name, presence: true, length: { maximum: 50 }
	validates :password, length: { minimum: 6 }

	before_save { self.email.downcase! }
  before_create :create_remember_token

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end
  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end
  def feed
    Micropost.from_users_followed_by(self)
    # Micropost.where("user_id = ?", id)
  end
  def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
  end
  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end
  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy!
  end

	has_secure_password

  private
    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
end
