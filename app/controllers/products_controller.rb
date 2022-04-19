class ProductsController < ApplicationController
  def index
    @q = Product.ransack(params[:q])
    @products = @q.result(distinct: true).paginate(page: params[:page], :per_page => 3).ordered_by_price
  end

  def new
    @product = Product.new
  end

  def create
    product = Product.create(product_params)
    redirect_to root_path
  end

  def show
    @product = Product.find_by_id(params[:id])
    if @product 
      flash[:info] = "Không tìm thấy thông tin sản phẩm"
      redirect_to products_path   
    end
  end

  private 
  def product_params
    params.require(:product).permit(:name, category_ids:[])
  end
end
