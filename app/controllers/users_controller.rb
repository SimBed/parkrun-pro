class UsersController < ApplicationController
  # allow_unauthenticated_access

  def index
    @users = User.all
  end
end
