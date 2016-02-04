# coding: utf-8
class TopicsController < ApplicationController
  before_action :sign_in_required, only: [:new, :create]
  before_action :set_topic, only: [:show]
  before_action :not_view_deleted_topic, only: [:show]

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

  def create
    @topic = Topic.new(topic_params)
    @topic.user_id = current_user.id
    respond_to do |format|
      if @topic.save
        format.html { redirect_to @topic, notice: '新しいトピックを作成しました' }
      else
        flash.now[:alert] = @topic.errors.full_messages
        format.html { render :new}
      end
    end
  end

  private
  def set_topic
    @topic = Topic.find(params[:id])
  end

  def topic_params
    params.require(:topic).permit(:title, :value, :category_id, :status, :bootsy_image_gallery_id)
  end

  def not_view_deleted_topic
    unless current_user.try(:admin?)
      if @topic.deleted?
        redirect_to root_path
      end
    end
  end
end
