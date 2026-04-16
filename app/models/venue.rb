class Venue < ApplicationRecord
  include DateManager
  scope :order_by_name, -> { order(verified: :desc, name: :asc) }

  def homepage
    "https://www.parkrun.org.uk/#{code_name}/"
  end

  def results_page(latest: false, date: nil)
    # /latestresults endpoint returns javascript which fetches from the yyyy-mm-dd endpoint.
    # /latestresults doesnt itself include the data we need.
    if latest
      "https://www.parkrun.org.uk/#{code_name}/results/#{DateManager.latest_results_date}/"
    else
      "https://www.parkrun.org.uk/#{code_name}/results/#{date}/"
    end
  end

  def latest_results_page
    # /latestresults endpoint returns javascript which fetches from the yyyy-mm-dd endpoint.
    # /latestresults doesnt itself include the data we need.
    "https://www.parkrun.org.uk/#{code_name}/results/#{DateManager.latest_results_date}/"
  end

  def address_page
    "https://www.parkrun.org.uk/#{code_name}/"
  end
end
