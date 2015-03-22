class ChangeUidFromMilestoneToString < ActiveRecord::Migration
  def change
    change_column :milestones, :uid, :string
  end
end
