class VenuesController < ApplicationController
  before_action :set_venue, only: %i[ edit update ]
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
    if @venue.save
      flash[:success] = "Venue was successfully created."
      redirect_to venues_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @venue.update(venue_params)
      redirect_to venues_path, notice: "Venue was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def set_venue
      @venue = Venue.find(params.expect(:id))
    end

    def venue_params
      params.expect(venue: [ :name, :code_name, :verified, :address, :postcode, :active ])
    end
end
