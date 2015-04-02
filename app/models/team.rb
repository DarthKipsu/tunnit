class Team < ActiveRecord::Base
  has_many :user_teams
  has_many :users, -> { uniq }, through: :user_teams
  has_many :projects, dependent: :destroy
  has_many :team_requests

  validates :name, presence: true
end
