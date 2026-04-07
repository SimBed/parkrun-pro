# db/seeds.rb
now = Time.current

data = Agegroup::DATA.map do |attrs|
  attrs.merge(created_at: now, updated_at: now)
end

Agegroup.upsert_all(data, unique_by: :name)
