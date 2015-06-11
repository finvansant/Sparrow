class FriendsController < ApplicationController
  before_action :authenticate_user!

  def index
    @friends = user_friends
  end

  def new
    @friend = Friend.new
  end

  def show
    @friend = Friend.find(params[:id])
    unless show?
      redirect_to root_url, notice: "Sorry, that action is not allowed."
    end 
  end

  def create
    @friend = Friend.create(friend_params)
    if @friend.save
      redirect_to friends_path
    else
      render "new"
    end
  end

  def edit
    @friend = Friend.find(params[:id])
    unless show?
      redirect_to root_url, notice: "Sorry, that action is not allowed."
    end 
  end

  def update
    @friend = Friend.find(params[:id])
    @friend.update(friend_params) 
    redirect_to friends_path
  end

  def destroy
    @friend = Friend.find(params[:id])
    @friend.destroy
    redirect_to friends_path
  end

  private

  def show?
    if user_friends.include?(@friend)
      true
    else
      false
    end
  end

  def user_friends
    friends = current_user.friends
  end

  def friend_params
     params.require(:friend).permit(:name, :phone, :user_id)
  end
end
