# in appplication.rb config.autoload_paths << Rails.root.join("lib") to ensure available to controllers and views without requiring it explicitly.
# config.eager_load_paths << Rails.root.join("lib") for production.

module Utility
  module TimeParser
    def self.parse_time_to_seconds(str)
      parts = str.split(":").map(&:to_i)

      case parts.length
      when 2
        m, s = parts
        m * 60 + s
      when 3
        h, m, s = parts
        h * 3600 + m * 60 + s
      else
        0
      end
    end

    def self.correct_time_format?(str)
      str&.match?(/\A\d{1,2}:\d{2}(:\d{2})?\z/)
    end
  end
end
