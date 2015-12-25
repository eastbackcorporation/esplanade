class ForumsController < ApplicationController
  before_action :set_date_params, only: [:search]
  before_action :set_status_params, only: [:search]
  def index
    unless current_user.try(:admin?)
      redirect_to "/forums/home"
    end
  end
  def home
    @categories = Category.where.not(status: Category.statuses[:deleted]).order("created_at asc")

    late = Time.now - 3.day
    @created_topics = Topic.where("created_at >= ?", late)
                           .where.not("status = ?",Topic.statuses[:deleted])
                           .order('created_at desc')

    @wrote_topics = Topic.joins(:comments)
                         .select("topics.*")
                         .where("comments.created_at >= ?", late)
                         .where.not("comments.status = ?", Comment.statuses[:deleted])
                         .where.not("topics.status = ?", Topic.statuses[:deleted])
                         .uniq
  end
  def search
    word =
      if params["word"]
        params["word"][0]
      else
        ""
      end
    topic_search={title_or_value_cont: word}
    comment_search={value_cont: word}
    @view_topics = params[:topic]
    @view_comments = params[:comment]
    @view_users = params[:user]

    if @view_topics.nil? and @view_comments.nil? and @view_users.nil?
      @view_topics = @view_comments = @view_users = true
    end
    topic_search.merge! @date_params
    comment_search.merge! @date_params
    if current_user.try(:admin?) and @view_users
      if @category_id.blank?
        @category_ids = Category.select(:id).where("status in (?)",@category_statuses)
      else
        @category_ids = [@category_id]
      end

      @topics = Topic.search(topic_search).result.where("status in (?)",@topic_statuses).where("category_id in (?)",@category_ids).page params[:page] if @view_topics
      @topic_ids = Topic.select(:id).where("category_id in (?)",@category_ids)
      @comments = Comment.search(comment_search).result.where("status in (?)",@comment_statuses).where("topic_id in (?)",@topic_ids).page params[:page] if @view_comments

      user_search={email_or_username_cont: word}
      user_search.merge! @date_params
      @users = User.search(user_search).result.where("status in (?)",@user_statuses).page params[:page]
    else
      if @category_id.blank?
        @category_ids = Category.select(:id).where.not(status: Category.statuses[:deleted])
      else
        @category_ids = [@category_id]
      end
      @topics = Topic.search(topic_search).result.where.not(status: Topic.statuses[:deleted]).where("category_id in (?)",@category_ids).page params[:page] if @view_topics
      @topic_ids = Topic.select(:id).where("category_id in (?)",@category_ids).where.not(status: Topic.statuses[:deleted])
      @comments = Comment.search(comment_search).result.where.not(status: Comment.statuses[:deleted]).where("topic_id in (?)",@topic_ids).page params[:page] if @view_comments
    end
  end
  def admin
  end

  private
  def set_status_params
    @category_statuses = []
    @topic_statuses = []
    @comment_statuses = []
    @user_statuses = []
    @category_id = 
      if params["category"]
        params["category"]["id"]
      else
        ""
      end
    if params["category_statuses"]
      params["category_statuses"].each_key do |s|
        @category_statuses << Category.statuses[s]
      end
    end
    if params["topic_statuses"]
      params["topic_statuses"].each_key do |s|
        @topic_statuses << Topic.statuses[s]
      end
    end
    if params["comment_statuses"]
      params["comment_statuses"].each_key do |s|
        @comment_statuses << Comment.statuses[s]
      end
    end
    if params["user_statuses"]
      params["user_statuses"].each_key do |s|
        @user_statuses << User.statuses[s]
      end
    end
    if @category_statuses.blank? and @topic_statuses.blank? and @comment_statuses.blank? and @user_statuses.blank?

      @category_statuses = Category.statuses.values
      @topic_statuses = Topic.statuses.values
      @comment_statuses = Comment.statuses.values
      @user_statuses = User.statuses.values
    end
  end
  def set_date_params
    @date_params={}
    if params["between"].present?
      case params["between"]["datetime"]
      when "appoint"
        year,month,day = params["created_at_gteq"][0].split("/")
        @date_params[:created_at_gteq] = 
          begin
            Time.new(year,month,day,0,0,0)
          rescue
            Time.new - 100.year
          end
        year,month,day = params["created_at_lteq"][0].split("/")
        @date_params[:created_at_lteq] =
          begin
            Time.new(year,month,day,24,0,0)
          rescue
            Time.new
          end
      when "1hour"
        @date_params[:created_at_gteq] = Time.now - 1.hour
        @date_params[:created_at_lteq] = Time.now
      when "24hours"
        @date_params[:created_at_gteq] = Time.now - 1.day
        @date_params[:created_at_lteq] = Time.now
      when "1week"
        @date_params[:created_at_gteq] = Time.now - 1.week
        @date_params[:created_at_lteq] = Time.now
      when "1month"
        @date_params[:created_at_gteq] = Time.now - 1.month
        @date_params[:created_at_lteq] = Time.now
      when "1year"
        @date_params[:created_at_gteq] = Time.now - 1.year
        @date_params[:created_at_lteq] = Time.now
      end
    end
  end
end
