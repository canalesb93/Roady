class AddFinishedToRaces < ActiveRecord::Migration
  def change
    add_column :user_races, :finished, :boolean, default: false
  end
end
