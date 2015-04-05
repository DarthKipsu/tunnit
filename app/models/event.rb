class Event < ActiveRecord::Base
  belongs_to :project

  validates :project_id, presence: true
  validates_datetime :end, after: :start

  def title
    Project.name_for(self.project_id)
  end
end
