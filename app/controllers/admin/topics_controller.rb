# coding: utf-8
class Admin::TopicsController < ApplicationController
  before_action :sign_in_required, only: [:new, :create]
  before_action :admin_required, only: [:index, :edit, :update, :destory]
  before_action :set_topic, only: [:show, :edit, :update, :destroy]
  before_action :not_view_deleted_topic, only: [:show]

  def index
    @column = params[:column].nil? ? :title : params[:column]
    @order = params[:order] == "asc" ? 'desc': 'asc'
    @topics = Topic.joins(:category,:user).all.order("#{@column} #{@order}").page params[:page]
  end

  def show
    if @topic.deleted? or @topic.category.deleted?
      msg = "このトピックは削除されています。" if @topic.deleted?
      msg = "もとのカテゴリが削除されています" if @topic.category.deleted?
      if current_user.try(:admin)
        flash[:notice] = msg
      else
        render text: msg
      end
    end

    @comment = Comment.new
    @comment.topic_id = @topic.id
    if user_signed_in?
      @comment.user_id = current_user.id
      @username = current_user.username
    end
  end

  def new
    @topic = Topic.new
    @topic.category_id = params[:category_id]
  end

  def edit
  end

  def create
    @topic = Topic.new(topic_params)
    @topic.user_id = current_user.id
    respond_to do |format|
      if @topic.save
        format.html { redirect_to @topic, notice: '新しいトピックを作成しました' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @topic.update(topic_params)
        format.html { redirect_to admin_topics_path, notice: '更新しました' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @topic.status = Topic.statuses[:deleted]
    respond_to do |format|
      if @topic.save
        format.html { redirect_to topics_url, notice: "#{@topic.title}は一般ユーザが閲覧できなくなりました" }
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_topic
    @topic = Topic.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def topic_params
    params.require(:topic).permit(:title, :value, :category_id, :status)
  end

  def not_view_deleted_topic
    unless current_user.try(:admin?)
      if @topic.deleted?
        redirect_to root_path
      end
    end
  end
end
