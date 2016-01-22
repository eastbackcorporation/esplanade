# coding: utf-8
class Admin::UsersController < ApplicationController
  before_action :admin_required
  before_action :set_user, only: [:show, :edit, :update]
  def index
    @users = User.all
  end

  def show
    @topics = Topic.where(user_id: @user.id)
    @comments = Comment.where(user_id: @user.id)
  end

  def edit
  end

  def update
    if user_params[:password].present?
      @user.password = user_params[:password]
      @user.password_confirmation = user_params[:password]
    end
    @user.email = user_params[:email]
    @user.username = user_params[:username]
    @user.status = user_params[:status]
    @user.admin = user_params[:admin]
    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'ユーザ情報を変更しました。' }
      else
        format.html { render :edit, notice: '変更できませんでした'}
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:email, :username, :password, :status, :admin)
    end
end
