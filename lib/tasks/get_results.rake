desc "scrape each parkrun venue endpoint for latest results"
task get_results: :environment do
  date = Date.parse("17 January 2026")
  count = 0
  # Venue.order(:id).limit(30).offset(274).each do |venue|
  # Venue.order(:id).limit(300).find_each(start: 834, batch_size: 10) do |venue|
  Venue.order(:id).limit(900).find_each(start: 834, batch_size: 10) do |venue|
      puts "processing #{venue.name}, id: #{venue.id}"
      rows = []
      time_now = Time.current
      response = WebsiteRequester.new(venue.results_page(date: date)).request
      # response = WebsiteRequester.new(venue.results_page(latest: true)).request
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
        venue_name = venue.name
        rows << { name:, gender:, agegroup:, time: seconds, position:, runs:, agegrade:,
                  parkrun: venue_name,
                  date:,
                  created_at: time_now,
                  updated_at: time_now
                }
      end
      Run.insert_all(rows)
      # sleep(rand(2..4)) # mitigate getting blocked
      # sleep_time = rand(1..3)
      sleep_time = rand * 8 + 2
      puts "sleeping for: #{sleep_time} seconds"
      sleep sleep_time # mitigate getting blocked
    count += 1
    if count % 10 == 0
      puts "quick rest"
      sleep_time = rand(40..70)
      puts "sleeping for: #{sleep_time} seconds"
      sleep sleep_time
    end
  end
end
