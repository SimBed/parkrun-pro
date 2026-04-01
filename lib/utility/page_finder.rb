module Utility
  module PageFinder
    def self.find_page(time_input, runs, pagy_limit)
      seconds = Utility::TimeParser.parse_time_to_seconds(time_input)

      position = runs.where("time < ?", seconds).count
      (position / pagy_limit) + 1
    end
  end
end
