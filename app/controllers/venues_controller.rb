class VenuesController < ApplicationController
  before_action :set_venue, only: %i[ edit update destroy ]
  allow_unauthenticated_access only: [ :index ]

  def index
    @venues = Venue.order_by_name
  end

  def new
    @venue = Venue.new
  end

  def edit
  end

  def create
    @venue = Venue.new(venue_params)

    respond_to do |format|
      if @venue.save
        format.html { redirect_to venues_path, notice: "Venue was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @venue.update(venue_params)
        format.html { redirect_to venues_path, notice: "Venue was successfully updated.", status: :see_other }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @venue.destroy!

    respond_to do |format|
      format.html { redirect_to venues_path, notice: "Venue was successfully destroyed.", status: :see_other }
    end
  end

  private
    def set_venue
      @venue = Venue.find(params.expect(:id))
    end

    def venue_params
      params.expect(venue: [ :name, :code_name, :verified, :address, :postcode, :active ])
    end

  def prepare_agegroups
    @agegroup_columns = { junior: Run.agegroup_like("J"),
                men: Run.agegroup_like("SM") + Run.agegroup_like("VM"),
                women: Run.agegroup_like("SW") + Run.agegroup_like("VW"),
                wheelchair: Run.agegroup_like("WC")
              }
  end

  def prepare_dates
    @dates = Run.dates.map { |date| date.strftime("%d %B %Y") }
  end
end
