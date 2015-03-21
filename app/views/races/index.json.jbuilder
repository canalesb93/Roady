json.array!(@races) do |race|
  json.extract! race, :id, :name, :map_id
  json.url race_url(race, format: :json)
end
