class Project < ActiveRecord::Base
  belongs_to :team
  has_many :events, dependent: :destroy
end
