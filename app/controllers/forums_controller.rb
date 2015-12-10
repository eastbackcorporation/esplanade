class ForumsController < ApplicationController
  def index
    unless current_user.try(:admin?)
      redirect_to "/forums/home"
    end
  end
  def home
    @categories = Category.all

    late = Time.now - 3.day
    @created_topics = Topic.search(created_at_gteq: late)
                      .result
                      .order('created_at desc')

    @wrote_topics = Comment.joins(:topic)
                    .select("topics.*")
                    .search(created_at_gteq: late)
                    .result
                    .order('created_at desc')
                    .uniq
  end
  def search
    #@categories = Category.search(title_cont: params["word"][0]).result
    word = params["word"][0]
    topic_search={title_or_value_cont: word}
    comment_search={value_cont: word}
    @view_topics = params[:topic]
    @view_comments = params[:comment]
    @view_users = params[:user]

    if @view_topics.nil? and @view_comments.nil? and @view_users.nil?
      @view_topics = @view_comments = @view_users = true
    end

    date_params={}
    if params["between"].present?
      case params["between"]["datetime"]
      when "appoint"
        year,month,day = params["created_at_gteq"][0].split("/")
        date_params[:created_at_gteq] = Time.new(year,month,day,0,0,0)
        year,month,day = params["created_at_lteq"][0].split("/")
        date_params[:created_at_lteq] = Time.new(year,month,day,24,0,0)
      when "1hour"
        date_params[:created_at_gteq] = Time.now - 1.hour
        date_params[:created_at_lteq] = Time.now
      when "24hours"
        date_params[:created_at_gteq] = Time.now - 1.day
        date_params[:created_at_lteq] = Time.now
      when "1week"
        date_params[:created_at_gteq] = Time.now - 1.week
        date_params[:created_at_lteq] = Time.now
      when "1month"
        date_params[:created_at_gteq] = Time.now - 1.month
        date_params[:created_at_lteq] = Time.now
      when "1year"
        date_params[:created_at_gteq] = Time.now - 1.year
        date_params[:created_at_lteq] = Time.now
      end
    end
    topic_search.merge! date_params
    comment_search.merge! date_params
    @topics = Topic.search(topic_search).result.page params[:page] if @view_topics
    @comments = Comment.search(comment_search).result.page params[:page] if @view_comments
    if current_user.try(:admin?) and @view_users
      user_search={email_or_username_cont: word}
      user_search.merge! date_params
      @users = User.search(user_search).result.page params[:page]
    end
  end
  def admin
  end
end
