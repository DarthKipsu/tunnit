class Project < ActiveRecord::Base
  belongs_to :team
  has_many :events, dependent: :destroy
  has_many :users, -> { uniq }, through: :team
  has_many :allocations

  validates :team_id, presence: true
  validates :name, presence: true

  def self.name_for(id)
    Project.find_by(id:id).name
  end

  def total_hours_used
    self.events.inject(0) { |sum, e| sum + e.duration }
  end

  def hours_used_by_user
    hours = create_hours_hash
    self.events.map do |e|
      user = User.find_by id: e.user_id
      hours[user.id][:hours] += e.duration
    end
    add_allocations hours
  end

  private
  def create_hours_hash
    hours = {}
    self.users.each do |user|
      hours[user.id] = { name: "#{user.forename} #{user.surname}", hours: 0, id: user.id }
    end
    hours
  end

  def add_allocations(hours)
    total = self.total_hours_used
    hours.map do |user|
      alloc = Allocation.find_by project_id: self.id, user_id: user[1][:id]
      if alloc.nil?
        user[1][:percent] = calc_percentages user[1][:hours], total
      else
        add_percentages_by_allocations user, alloc.alloc_hours
      end
    end
    hours
  end

  def calc_percentages(hours, total)
    return hours / total * 100
  end

  def add_percentages_by_allocations(user, alloc)
    user[1][:alloc_hours] = alloc.to_s
    user[1][:percent] = calc_percentages user[1][:hours], alloc.to_f
    if user[1][:percent] > 100
      user[1][:over] = calc_percentages user[1][:hours] - alloc.to_f, user[1][:hours]
      user[1][:percent] = calc_percentages alloc.to_f, user[1][:hours]
    end
  end
end
