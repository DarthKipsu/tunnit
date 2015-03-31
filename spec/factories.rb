FactoryGirl.define do
  factory :user do
    forename "Mikko"
    surname "Makkonen"
    email "test@test.fi"
    password "Salainen1"
    password_confirmation "Salainen1"
  end

  factory :team do
    name "Personal projects"
  end

  factory :project do
    name "My project"
    team_id 1
  end

  factory :event do
    project_id 1
    title "Project name"
    sequence(:start) { |t| DateTime.now }
    sequence(:end) { |t| DateTime.now + (6) }
  end
end
