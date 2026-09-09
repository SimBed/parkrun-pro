class MpsController < ApplicationController
  before_action :set_mp, only: %i[ show edit update destroy ]
  allow_unauthenticated_access # only: [ :index ]

  # GET /mps or /mps.json
  def index
    @sort_option = params[:sort_option] || "pb"
    @sort_direction = params[:sort_direction] || "asc"
    @next_direction = @sort_direction == "asc" ? "desc" : "asc"
    @mps = Mp.order(@sort_option => @sort_direction, pb: :asc)
    @mp_size = @mps.size
  end

  # GET /mps/1 or /mps/1.json
  def show
  end

  # GET /mps/new
  def new
    @mp = Mp.new
  end

  # GET /mps/1/edit
  def edit
  end

  def create
    @mp = Mp.new(mp_params)
    if @mp.save
      flash[:success] = "MP was successfully created."
      redirect_to mps_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /mps/1 or /mps/1.json
  def update
    if @mp.update(mp_params)
      redirect_to mps_path, notice: "Mp was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /mps/1 or /mps/1.json
  def destroy
    @mp.destroy!

    respond_to do |format|
      format.html { redirect_to mps_path, notice: "Mp was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mp
      @mp = Mp.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def mp_params
      params.expect(mp: [ :name, :party, :constituency, :agegroup, :pb, :date, :venue, :runs ])
    end
end
