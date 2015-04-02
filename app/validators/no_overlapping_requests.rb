class NoOverlappingRequests < ActiveModel::Validator
  def validate(record)
    user = User.find_by_id record.target_id
    if user.nil?
      record.errors.clear
      record.errors[:base] << "User not found"
      return
    end
    
    if user.team_requests.any? { |request| request.team_id.eql? record.team_id }
      record.errors[:base] << "This email allready has a pending request to join the team"
    end

    if user.teams.any? { |team| team.id.eql? record.team_id }
      record.errors[:base] << "This user is allready a member of this team"
    end
  end
end
