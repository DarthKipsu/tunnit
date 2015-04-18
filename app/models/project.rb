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

  def hours_between(start_time, end_time)
    hours = Hash.new
    hours[:users] = {}
    total_hours = 0;
    users.each do |u|
      hours_by_user = u.hours_between(start_time, end_time)[:projects][self.name.to_sym]
      hours[:users]["#{u.forename} #{u.surname}"] = hours_by_user
      total_hours += hours_by_user
    end
    hours[:total] = total_hours
    hours
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
    if total.zero?
      return 0
    end
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
