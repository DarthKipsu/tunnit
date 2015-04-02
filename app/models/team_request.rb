class TeamRequest < ActiveRecord::Base
  belongs_to :target, class_name: 'User', foreign_key: 'target_id'
  belongs_to :source, class_name: 'User', foreign_key: 'source_id'
  belongs_to :team
  
  validates :target_id, :source_id, :team_id, presence: true
  validates_with NoOverlappingRequests

  def self.for_email(email, team_id, source_id)
    target = User.find_by(email: email)
    target = target.id unless target.nil?
    TeamRequest.new(date: DateTime.now, target_id: target, source_id: source_id, team_id: team_id)
  end
end
