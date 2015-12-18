# coding: utf-8
class CommentsController < ApplicationController
  before_action :sign_in_required, only: [:new, :create]
  before_action :admin_required, only: [:edit, :update, :destory]
  before_action :set_comment, only: [:show, :edit, :update, :destroy]

  def index
    @column = params[:column].nil? ? :title : params[:column]
    @order = params[:order] == "asc" ? 'desc': 'asc'
    @comments = Comment.joins(:topic,:user).all.order("#{@column} #{@order}").page params[:page]
  end

  def show
    redirect_to forums_path
  end

  def new
    @comment = Comment.new
  end

  def edit
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.user_id = current_user.id
    @comment.topic.touch
    respond_to do |format|
      if @comment.save
        format.html { redirect_to @comment.topic, notice: "コメントを作成しました" }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
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
  # Use callbacks to share common setup or constraints between actions.
  def set_comment
    @comment = Comment.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def comment_params
    params.require(:comment).permit(:value, :topic_id, :image, :image_cache, :remove_image)
  end
end
