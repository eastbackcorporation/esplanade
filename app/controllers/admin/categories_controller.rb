class Admin::CategoriesController < Admin::AdminController
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  def index
    @column = params[:column].nil? ? :title : params[:column]
    @order = params[:order] == "asc" ? 'desc': 'asc'
    @categories = Category.all.order("#{@column} #{@order}").page params[:page]
  end

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

  # GET /categories/new
  def new
    @category = Category.new
  end

  # GET /categories/1/edit
  def edit
  end

  def create
    @category = Category.new(category_params)

    respond_to do |format|
      if @category.save
        format.html { redirect_to admin_categories_path, notice: '新しいカテゴリを作成しました' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to admin_categories_path, notice: '更新しました' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @category.status = Category.statuses[:deleted]
    if @category.save
      respond_to do |format|
        format.html { redirect_to categories_url, notice: '関連するトピック、コメントは表示されなくなりました。' }
      end
    end
  end
  private
  # Use callbacks to share common setup or constraints between actions.
  def set_category
    @category = Category.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def category_params
    params.require(:category).permit(:title, :image, :status, :image_cache, :remove_image)
  end
end
