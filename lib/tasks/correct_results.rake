desc "correct bulk mis-scrapes"
task correct_runs: :environment do
  start_date = Date.new(2026, 5, 2)
  end_date = Date.new(2026, 5, 2)
  dates = (start_date..end_date).step(7).to_a
  [ "Burnham and Highbridge", "Jersey Farm", "Sixfields Upton", "Hartlepool", "South Shields", "Troon", "Camperdown", "Simmons Park",
  "Horspath", "Orangefield", "Squerryes Winery", "Ross-on-Wye", "Halifax", "Carrickfergus", "Rogiet", "Harcourt Hill", "Omagh",
  "Chevin Forest", "Great Dunmow", "Crawfordsburn Country", "Palacerigg Country", "Garvagh Forest" ].each do |venue_name|
    venue = Venue.find_by(name: venue_name)
    next unless venue
    dates.each do |date|
      Run.where(venue: venue_name, date: start_date).delete_all
      puts "processing #{venue_name} for date: #{date}"
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
                  venue: venue_name,
                  date:,
                  created_at: time_now,
                  updated_at: time_now
                }
      end
      Run.insert_all(rows)
    end
  end
end
