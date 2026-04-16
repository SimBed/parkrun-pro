desc "scrape new venues for hitoric results"
task get_historic_results: :environment do
  start_date = Date.new(2026, 1, 3)
  end_date = Date.new(2026, 4, 11)
  dates = (start_date..end_date).step(7).to_a
  # ["christchurch", "belvoirforest", "yorkcommunitywoodland", "brookleys", "greenwichpeninsula"].each do |code_name|
  [ "greenwichpeninsula" ].each do |code_name|
    venue = Venue.find_by(code_name:)
    next unless venue
    venue_name = venue.name
    dates.each do |date|
      puts "processing #{venue_name}, id: #{venue.id} for date: #{date}"
      rows = []
      time_now = Time.current
      response = WebsiteRequester.new(venue.results_page(date: date)).request
      exit if response.nil?
      next if response == "not found"
      noko_doc = Nokogiri::HTML(response)
      noko_doc.css("tr.Results-table-row").each do |row|
        name = row["data-name"]
        next if [ "Unknown", "" ].include? name
        gender = row["data-gender"]
        agegroup = row["data-agegroup"]
        position = row["data-position"]
        runs = row["data-runs"]
        agegrade = row["data-agegrade"]
        time = row.at_css("td.Results-table-td--time div")&.text&.strip
        time_parts = time.split(":").map(&:to_i)
        seconds =
          if time_parts.length == 2
            minutes, secs = time_parts
            minutes * 60 + secs
          else
            hours, minutes, secs = time_parts
            hours * 3600 + minutes * 60 + secs
          end
        rows << { name:, gender:, agegroup:, time: seconds, position:, runs:, agegrade:,
                  parkrun: venue_name,
                  date:,
                  created_at: time_now,
                  updated_at: time_now
                }
      end
      Run.insert_all(rows)
    end
  end
end
