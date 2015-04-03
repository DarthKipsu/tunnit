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
    pending = TeamRequest.pending_for(self.id)
    changed = TeamRequest.changed_status_for(self.id)
    message = request_message(pending, changed)
    changed.each { |r| r.destroy! }
    { pending: pending, message: message, display: pending.count > 0 }
  end

  private
  def request_message(pending, changed)
    if !changed.empty?
      message = "Team requests you have sent have changed"
      changed.each { |r| message << "; #{Team.name_for_id(r.team_id)}: #{User.find_by(id:r.target_id).forename} #{r.status}" }
    elsif !pending.empty?
      message = "You have pending team requests"
      pending.each { |r| message << "; #{Team.name_for_id(r.team_id)}" }
    end
    message
  end
end
