class User < ActiveRecord::Base
  has_many :user_teams
  has_many :teams, -> { uniq }, through: :user_teams
  has_many :projects, -> { uniq }, through: :teams
  has_many :events, -> { uniq }, through: :projects

  has_secure_password

  validates :password, length: { minimum: 4 },
    format: { with: /([A-Z]\D*\d|\d\D*[A-Z])/,
              message: "must contain at least one capital letter and one number" }
  validates :email, uniqueness: true, presence: true
  validates_format_of :email, :with => /@/

  def recent_teams
    teams.order(updated_at: :desc)
  end
end
