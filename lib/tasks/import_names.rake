desc "import parkrun names from file"
task import_names: :environment do
  names = File.open "parkrun_names.txt" do |file|
        file.readlines.map(&:chomp)
                      .reject { |name| name.match?(/juniors/) }
                      .map { |name| { name:, code_name: name.split.join.downcase } }
                      .uniq
  end
  # names.each do |name|
  # Parkrun.create!(name:)
  # end
  # one database hit - insert_all takes an array of hashes
  Parkrun.insert_all names
  # puts names.length
  # puts names.take(20)
end
