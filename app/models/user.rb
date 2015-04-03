class User < ActiveRecord::Base
  has_many :user_teams
  has_many :teams, -> { uniq }, through: :user_teams
  has_many :projects, -> { uniq }, through: :teams
  has_many :events, -> { uniq }, through: :projects
  has_many :team_requests, class_name: 'TeamRequest', foreign_key: 'target_id'
  has_many :sent_requests, class_name: 'TeamRequest', foreign_key: 'source_id'

  has_secure_password

  validates :password, length: { minimum: 4 },
    format: { with: /([A-Z]\D*\d|\d\D*[A-Z])/,
              message: "must contain at least one capital letter and one number" }
  validates :email, uniqueness: true, presence: true
  validates_format_of :email, :with => /@/

  def recent_teams
    teams.order(updated_at: :desc)
  end

  def pending_requests
    req = TeamRequest.pending_for(self.id)
    message = "You have pending team requests"
    req.each { |r| message << "; #{Team.name_for_id(r.team_id)}" }
    if req.count.zero? then message = nil end
    { teams: req, message: message, display: req.count > 0 }
  end
end
