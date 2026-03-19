desc "scrape each parkrun endpoint for latest results"
task get_results: :environment do
  Parkrun.order(:id).limit(25).offset(809).each do |parkrun|
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
      rows << { name:, gender:, agegroup:, position:, runs:, agegrade:, parkrun_name:,
                time: seconds,
                created_at: time_now,
                updated_at: time_now
              }
    end
    Runner.insert_all(rows)
    # sleep(rand(2..4)) # avoid getting blocked
    sleep(rand * 8 + 2) # avoid getting blocked
  end
end
