class AddUserIdToEvents < ActiveRecord::Migration
  def change
    add_column :events, :user_id, :integer

    Event.all.each{ |e| e.update_attribute(:user_id, e.project.users.first.id) }
  end
end
