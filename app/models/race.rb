class Race < ActiveRecord::Base

  has_many :user_races, dependent: :destroy
  has_many :users, through: :user_races

end
