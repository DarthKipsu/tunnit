class Project < ActiveRecord::Base
  belongs_to :team
  has_many :events, dependent: :destroy
  has_many :users, -> { uniq }, through: :team

  validates :team_id, presence: true
  validates :name, presence: true
end
