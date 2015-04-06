class Allocation < ActiveRecord::Base
  belongs_to :project
  belongs_to :user

  validates :alloc_hours, :numericality => { :greater_than_or_equal_to => 0 }
end
