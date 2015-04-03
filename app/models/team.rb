class Team < ActiveRecord::Base
  has_many :user_teams
  has_many :users, -> { uniq }, through: :user_teams
  has_many :projects, dependent: :destroy
  has_many :team_requests

  validates :name, presence: true

  def self.name_for_id(id)
    Team.find_by(id:id).name
  end

  def self.add_user_to(id, user)
    Team.find_by(id:id).users << user
  end
end
