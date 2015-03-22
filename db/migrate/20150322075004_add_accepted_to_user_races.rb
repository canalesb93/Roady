class AddAcceptedToUserRaces < ActiveRecord::Migration
  def change
    add_column :user_races, :accepted, :boolean, default: false
  end
end
