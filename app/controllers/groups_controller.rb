class GroupsController < ApplicationController
  before_action :authenticate_user!

  def index
    @groups = user_groups
  end

  def new
    @group = Group.new
  end

  def show
    @group = Group.find(params[:id])
    unless show?
      redirect_to root_url, notice: "Sorry, that action is not allowed."
    end
  end

  def create
    @group = Group.create(group_params)
    if @group.save
      redirect_to groups_path, notice: "Group created."
    else
      # something
      render "new"
    end
  end

  def edit
    @group = Group.find(params[:id])
    unless show?
      redirect_to root_url, notice: "Sorry, that action is not allowed."
    end
  end

  def update
    @group = Group.find(params[:id])
    if @group.update(group_params)
      redirect_to groups_path, notice: "Group updated."
    else
      render "edit"  
    end
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    redirect_to groups_path
  end

  private

  def show?
    if user_groups.include?(@group)
      true
    else
      false
    end
  end

  def user_groups
    groups = current_user.groups
  end

  def group_params
     params.require(:group).permit(:name, :user_id, friend_ids: [])
  end
end
