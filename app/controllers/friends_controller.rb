class FriendsController < ApplicationController
  allow_unauthenticated_access
  def index
    # @runs = (Run.name_like(params[:names]) if params[:names].present?) || Run.none
    @runs = Run.name_like(params[:names]).order(time: :asc)
  end
end
