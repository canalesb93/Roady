class CreateMilestones < ActiveRecord::Migration
  def change
    create_table :milestones do |t|
      t.string :message
      t.string :name
      t.string :race_name

      t.timestamps
    end
  end
end
