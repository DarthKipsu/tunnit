class NoOverlappingRequests < ActiveModel::Validator
  def validate(record)
    user = User.find_by_id record.target_id
    if user.nil?
      record.errors.clear
      record.errors[:base] << "User not found"
      return
    end

    if record.status.nil?
      if user.team_requests.any? { |request| request.team_id.eql? record.team_id }
        add_error_message record, "This email allready has a pending request to join the team"
      end

      if user.teams.any? { |team| team.id.eql? record.team_id }
        add_error_message record, "This user is allready a member of this team"
      end
    end
  end

  private
  def add_error_message(record, message)
    record.errors[:base] << message
  end
end
