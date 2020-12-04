class User < ApplicationRecord
  has_many :friendships
  has_many :friends, through: :friendships

  validates :name, uniqueness: true
end
