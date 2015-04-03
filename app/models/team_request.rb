class TeamRequest < ActiveRecord::Base
  belongs_to :target, class_name: 'User', foreign_key: 'target_id'
  belongs_to :source, class_name: 'User', foreign_key: 'source_id'
  belongs_to :team

  scope :pending_for, -> (user_id) { where(target_id: user_id, status: nil) }
  scope :changed_status_for, -> (user_id) { where(source_id: user_id, status: ['accepted', 'declined']) }
  
  validates :target_id, :source_id, :team_id, presence: true
  validates_with NoOverlappingRequests

  def self.for_email(email, team_id, source_id)
    target = User.find_by(email: email)
    target = target.id unless target.nil?
    TeamRequest.new(date: DateTime.now, target_id: target, source_id: source_id, team_id: team_id)
  end

  def accept_request(user, team_id)
    Team.add_user_to team_id, user
    change_status 'accepted'
  end

  def decline_request
    change_status 'declined'
  end

  private
  def change_status(status)
    self.status = status
    self.save!
  end
end
