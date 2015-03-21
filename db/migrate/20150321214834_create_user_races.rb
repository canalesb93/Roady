class CreateUserRaces < ActiveRecord::Migration
  def change
    create_table :user_races do |t|
      t.integer :user_id
      t.integer :race_id
      t.decimal :lat, {:precision=>10, :scale=>7}
      t.decimal :lng, {:precision=>10, :scale=>7}
      t.timestamps
    end
  end
end
