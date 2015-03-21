class CreateRaces < ActiveRecord::Migration
  def change
    create_table :races do |t|
      t.string :name
      t.string :map_id
      t.decimal :lat, {:precision=>10, :scale=>7}
      t.decimal :lng, {:precision=>10, :scale=>7}
      t.timestamps
    end
  end
end
