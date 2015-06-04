class UserController < ApplicationController

  def index

  end

  def show
    @user = User.find(params[:id])
    @groups = @user.groups
    @friends = @user.friends
  end

end
