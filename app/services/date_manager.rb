# frozen_string_literal: false

require "active_support"
require "active_support/core_ext/date/calculations"

module DateManager
  def self.latest_results_date
    Date.tomorrow.prev_occurring(:saturday)
  end
end
