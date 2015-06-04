class FriendsController < ApplicationController
  def index
    @friends = Friend.all
  end

  def new
    @friend = Friend.new
  end

  def show
    @friend = Friend.find(params[:id])
  end

  def create
    @friend = Friend.create(friend_params)
    redirect_to friends_path
  end

  def edit
    @friend = Friend.find(params[:id])
  end

  def update
  end

  def destroy
    @friend = Friend.find(params[:id])
    @friend.destroy
    redirect_to friends_path
  end

  private

  def friend_params
     params.require(:friend).permit(:name, :phone, :user_id)
  end
end
