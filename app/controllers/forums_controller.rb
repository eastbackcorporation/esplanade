class ForumsController < ApplicationController
  def index
  end
  def search
    #@categories = Category.search(title_cont: params["word"][0]).result
    @topics = Topic.search(title_or_value_cont: params["word"][0]).result
    @comments = Comment.search(value_cont: params["word"][0]).result
  end

  def admin
  end
end
