class Venue < ApplicationRecord
  include DateManager
  scope :order_by_name, -> { order(verified: :desc, name: :asc) }

  def homepage
    "https://www.parkrun.org.uk/#{code_name}/"
  end

  def latest_results_page
    # /latestresults endpoint returns javascript which fetches from the yyyy-mm-dd endpoint.
    # /latestresults doesnt itself include the data we need.
    "https://www.parkrun.org.uk/#{code_name}/results/#{DateManager.latest_results_date}/"
  end

  # def self.stats(agegroups)
  #   # Run.where(parkrun: name).pluck(Arel.sql(<<~SQL)).first
  #   #   COUNT(time),
  #   #   AVG(time),
  #   #   STDDEV(time),
  #   #   MIN(time),
  #   #   MAX(time),
  #   #   percentile_cont(0.5) WITHIN GROUP (ORDER BY time)
  #   # SQL
  #   Run.connection.select_all(<<~SQL)
  #     SELECT
  #       parkrun,
  #       COUNT(time) AS count,
  #       AVG(time) AS mean,
  #       STDDEV(time) AS stddev,
  #       MIN(time) AS min,
  #       MAX(time) AS max,
  #       percentile_cont(0.5) WITHIN GROUP (ORDER BY time) AS median
  #     FROM runs
  #     GROUP BY parkrun
  #     ORDER BY parkrun
  #   SQL
  # end
end
