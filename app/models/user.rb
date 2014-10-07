class User < ActiveRecord::Base
	# VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	VALID_EMAIL_REGEX = /\A([\w+]|\b[\-.]{1})+\b@\b([a-z\d]|\b[\-.]{1})+\b[\.]{1}[a-z]+\z/i

	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, 
		uniqueness: { case_sensitive: false }
	validates :name, presence: true, length: { maximum: 50 }
	validates :password, length: { minimum: 6 }

	before_save { self.email.downcase! }

	has_secure_password
end
