class Politician < ApplicationRecord
  scope :runners, -> { where(runner: true) }
  scope :order_by_name_asc, -> { order(:last_name, :first_name) }
end
