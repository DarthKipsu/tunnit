class AddTitleAndRemoveTimeZoneFromEvents < ActiveRecord::Migration
  def change
    add_column :events, :title, :string
    remove_column :events, :timezone, :integer
  end
end
