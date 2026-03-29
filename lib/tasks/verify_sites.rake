desc "verify each parkrun venue homepage exists"
task verify_sites: :environment do
  Venue.where.not(verified: true).each do |venue|
    venue.update(verified: true) if WebsiteRequester.new(venue.homepage).request
  end
end
