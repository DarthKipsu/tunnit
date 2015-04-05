class Project < ActiveRecord::Base
  belongs_to :team
  has_many :events, dependent: :destroy
  has_many :users, -> { uniq }, through: :team

  validates :team_id, presence: true
  validates :name, presence: true

  def self.name_for(id)
    Project.find_by(id:id).name
  end

  def total_hours_used
    self.events.inject(0) { |sum, e| sum + e.duration }
  end

  def hours_used_by_user
    hours = Hash.new(0)
    self.events.map do |e|
      user = User.find_by id: e.user_id
      hours["#{user.forename} #{user.surname}"] += e.duration
    end
    return hours
  end
end
