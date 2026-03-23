desc "scrape each parkrun endpoint for latest results"
task get_results: :environment do
  date = Date.parse("21 March 2026")
  count = 0
  # Parkrun.order(:id).limit(30).offset(274).each do |parkrun|
  Parkrun.order(:id).limit(100).find_each(start: 1595, batch_size: 20) do |parkrun|
      puts "processing #{parkrun.name}, id: #{parkrun.id}"
      rows = []
      time_now = Time.current
      response = WebsiteRequester.new(parkrun.latest_results_page).request
      exit if response.nil?
      next if response == "not found"
      noko_doc = Nokogiri::HTML(response)
      noko_doc.css("tr.Results-table-row").each do |row|
        name = row["data-name"]
        next if name == "Unknown"
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
        parkrun_name = parkrun.name
        rows << { name:, gender:, agegroup:, time: seconds, position:, runs:, agegrade:,
                  parkrun: parkrun_name,
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
    if count % 20 == 0
      puts "quick rest"
      sleep_time = rand(60..62)
      puts "sleeping for: #{sleep_time} seconds"
      sleep sleep_time
    end
  end
end
