class AddUidToMilestone < ActiveRecord::Migration
  def change
    add_column :milestones, :uid, :integer
  end
end
