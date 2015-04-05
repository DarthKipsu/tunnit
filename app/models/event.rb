class Event < ActiveRecord::Base
  belongs_to :project
  belongs_to :user

  validates :project_id, presence: true
  validates_datetime :end, after: :start

  def title
    Project.name_for(self.project_id)
  end

  def duration
    (self.end - self.start) / 3600
  end
end
