class Team < ActiveRecord::Base
  has_many :user_teams
  has_many :users, -> { uniq }, through: :user_teams
  has_many :projects, dependent: :destroy

  validates :name, presence: true
end
