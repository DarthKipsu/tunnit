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
    user_id 1
    sequence(:start) { |t| DateTime.now }
    sequence(:end) { |t| DateTime.now + 2.hours }
  end

  factory :team_request do
    target_id 1
    source_id 2
    team_id 2
    sequence(:date) { |t| DateTime.now }
  end
end
