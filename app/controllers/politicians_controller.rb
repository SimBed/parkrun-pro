class PoliticiansController < ApplicationController
  def index
    @politicians = Politician.runners.order_by_name_asc
  end
end
