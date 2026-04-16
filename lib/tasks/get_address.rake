desc "scrape each parkrun venue for address"
task get_address: :environment do
  # Venue.order(:id).each do |venue|
  Venue.where(address: nil).order(:id).each do |venue|
    puts "processing #{venue.name}, id: #{venue.id}"
    response = WebsiteRequester.new(venue.address_page).request
    exit if response.nil?
    next if response == "not found"

    noko_doc = Nokogiri::HTML(response)
    heading = noko_doc.css("h4").find { |h| h.text.include?("Where is it?") }
    p_address_tag = heading&.next_element
    puts "#{venue.name} address not found" if p_address_tag.nil?
    next if p_address_tag.nil?

    address_text = p_address_tag.text
    address = address_text[/The event takes place at (.*?)\s?\. See/m, 1]
    puts "#{venue.name} address not found" if address.nil?
    next if address.nil?

    venue.update(address: address)
  end
end
