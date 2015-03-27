class User < ActiveRecord::Base
  has_many :user_teams
  has_many :teams, -> { uniq }, through: :user_teams

  has_secure_password
end
