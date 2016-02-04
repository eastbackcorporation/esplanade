# coding: utf-8
class Admin::CommentsController < Admin::AdminController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]

  def index
    @column = params[:column].nil? ? :title : params[:column]
    @order = params[:order] == "asc" ? 'desc': 'asc'
    @comments = Comment.joins(:topic,:user).all.order("#{@column} #{@order}").page params[:page]
  end

  def edit
  end

  def update
    respond_to do |format|
=begin
      status = comment_params[:status]
      if status == "deleted" and @comment.active? and @comment.image?
        @comment.image.logical_delete_all
      end
      if status == "active" and @comment.deleted? and @comment.image?
        @comment.image.logical_restore_all
      end
=end
      if @comment.update(comment_params)
        format.html { redirect_to admin_comments_path, notice: '更新しました' }
      else
        flash.now[:alert] = @comment.errors.full_messages
        format.html { render :edit }
      end
    end
  end

  def destroy
    @comment.status = Comment.statuses[:deleted]
    if  @comment.save
      respond_to do |format|
        format.html { redirect_to comments_url, notice: 'コメントは表示されなくなりました。' }
      end
    end
  end

  private
  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:value, :topic_id, :status)
  end
end
