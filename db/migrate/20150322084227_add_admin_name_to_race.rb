class AddAdminNameToRace < ActiveRecord::Migration
  def change
    add_column :races, :admin_name, :string
  end
end
