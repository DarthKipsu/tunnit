class Event < ActiveRecord::Base
  belongs_to :project

  validates :title, presence: true
  validates :project_id, presence: true
  validates_datetime :end, after: :start
end
