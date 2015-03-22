class AddFinishedToRaces < ActiveRecord::Migration
  def change
    add_column :races, :finished, :boolean, default: false
  end
end
