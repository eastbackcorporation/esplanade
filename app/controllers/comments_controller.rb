# coding: utf-8
class CommentsController < ApplicationController
  before_action :sign_in_required, only: [:new, :create]

  def new
    @comment = Comment.new
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.user_id = current_user.id
    @comment.topic.touch
    respond_to do |format|
      if @comment.save
        format.html { redirect_to @comment.topic, notice: "コメントを作成しました" }
      else
        format.html { redirect_to @comment.topic, alert: @comment.errors.full_messages }
      end
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:value, :topic_id, :status, :bootsy_image_gallery_id)
  end
end
