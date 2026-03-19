class ParkrunsController < ApplicationController
  before_action :set_parkrun, only: %i[ edit update destroy ]
  allow_unauthenticated_access only: :index
  def index
    @parkruns = Parkrun.order_by_name
  end

  def new
    @parkrun = Parkrun.new
  end

  def edit
  end

  def create
    @parkrun = Parkrun.new(parkrun_params)

    respond_to do |format|
      if @parkrun.save
        format.html { redirect_to parkruns_path, notice: "Parkrun was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @parkrun.update(parkrun_params)
        format.html { redirect_to parkruns_path, notice: "Parkrun was successfully updated.", status: :see_other }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @parkrun.destroy!

    respond_to do |format|
      format.html { redirect_to parkruns_path, notice: "Parkrun was successfully destroyed.", status: :see_other }
    end
  end

  private
    def set_parkrun
      @parkrun = Parkrun.find(params.expect(:id))
    end

    def parkrun_params
      params.expect(parkrun: [ :name, :code_name, :verified ])
    end
end
