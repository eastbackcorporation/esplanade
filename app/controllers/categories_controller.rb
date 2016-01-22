class CategoriesController < ApplicationController
  before_action :set_category, only: [:show]

  def show
    if @category.deleted?
      msg = "カテゴリが削除されています"
      if current_user.try(:admin)
        flash[:notice] = msg
      else
        render text: msg
      end
    end
  end

  private
  def set_category
    @category = Category.find(params[:id])
  end
end
