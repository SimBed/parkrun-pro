desc "import parkrun venue names from file"
task import_names: :environment do
  names = File.open "venue_names.txt" do |file|
        file.readlines.map(&:chomp)
                      .reject { |name| name.match?(/juniors/) }
                      .map { |name| { name:, code_name: name.split.join.downcase } }
                      .uniq
  end
  # one database hit - insert_all takes an array of hashes
  Venue.insert_all names
end
