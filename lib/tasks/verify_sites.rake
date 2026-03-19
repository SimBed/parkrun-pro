desc "verify each parkrun homepage exists"
task verify_sites: :environment do
  Parkrun.where.not(verified: true).each do |parkrun|
    parkrun.update(verified: true) if WebsiteRequester.new(parkrun.homepage).request
  end
end
