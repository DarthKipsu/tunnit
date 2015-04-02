class CreateTeamRequests < ActiveRecord::Migration
  def change
    create_table :team_requests do |t|
      t.integer :target_id
      t.integer :source_id
      t.datetime :date
      t.string :status
      t.integer :team_id

      t.timestamps null: false
    end
  end
end
