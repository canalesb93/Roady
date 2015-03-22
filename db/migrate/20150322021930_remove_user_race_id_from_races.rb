class RemoveUserRaceIdFromRaces < ActiveRecord::Migration
  def change
    remove_column :races, :user_races_id
  end
end
