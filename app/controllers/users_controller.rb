class UsersController < ApplicationController
  before_action :admin_required
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @topics = Topic.where(user_id: @user.id)
    @comments = Comment.where(user_id: @user.id)
  end
end
