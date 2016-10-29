# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string
#  email           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string
#  remember_digest :string
#

class User < ApplicationRecord
attr_accessor :remember_token
has_secure_password
validates(:name, presence: true, length: {maximum:50})
validates :email, presence: true
has_many :microposts, dependent: :destroy

def User.digest(string)
  cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
end

def User.new_token
    SecureRandom.urlsafe_base64
end

def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
end

def authenticated?(remember_token)
        BCrypt::Password.new(remember_digest).is_password?(remember_token)
end

end
