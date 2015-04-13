class User < ActiveRecord::Base
  has_many :user_teams
  has_many :teams, -> { uniq }, through: :user_teams
  has_many :projects, -> { uniq }, through: :teams
  has_many :events, -> { uniq }
  has_many :team_requests, class_name: 'TeamRequest', foreign_key: 'target_id'
  has_many :sent_requests, class_name: 'TeamRequest', foreign_key: 'source_id'
  has_many :allocations

  has_secure_password

  validates :password, length: { minimum: 4 },
    format: { with: /([A-Z]\D*\d|\d\D*[A-Z])/,
              message: "must contain at least one capital letter and one number" }
  validates :email, uniqueness: true, presence: true
  validates_format_of :email, :with => /@/

  def recent_teams
    teams.joins(:projects).order(updated_at: :desc)
  end

  def pending_requests
    pending = TeamRequest.pending_for(self.id)
    changed = TeamRequest.changed_status_for(self.id)
    message = request_message(pending, changed)
    changed.each { |r| r.destroy! }
    { pending: pending, message: message, display: pending.count > 0 }
  end

  def team_member?(user)
    user.id == self.id || !(team_ids(user) & team_ids(self)).empty?
  end

  def shared_teams_with(user)
    user.teams & self.teams
  end

  def shared_projects_with(user)
    user.projects & self.projects
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

  def team_ids(user)
    user.teams.map{ |t| t.id }
  end
end
