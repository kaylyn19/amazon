class ProductsController < ApplicationController
    before_action :product_params, only: [:create, :update]
    before_action :find_product, only: [:show, :edit, :destroy, :update]
    before_action :authenticate_user!, except: [:show, :index]
    before_action :authorize, only: [:destroy, :update, :edit]
    def new
        @product = Product.new
    end

    def create
        flash[:notice] = "Product added!"
        # product_params = params.require(:product).permit(:title, :description, :price, :sales_price)
        @product = Product.new product_params
        @product.user = current_user
        if @product.save
            redirect_to show_product_path(@product)
            # render plain: "product saved!"
        else
            render :new
        end
    end

    def show
        # @product = Product.find params[:id]
        @review = Review.new # instantiates and creates and object of Parameters
        @reviews = @product.reviews.order(created_at: :desc)
    end

    def index
        @product = Product.all.order('updated_at desc')
    end

    def destroy
        flash[:notice] = "Product deleted!"
        # product = Product.find params[:id]
        product.destroy
        redirect_to index_path
    end

    def edit
        # @product = Product.find params[:id]
    end

    def update
        # product_params = params.require(:product).permit(:title, :description, :price, :sales_price)
        # @product = Product.find params[:id]
        if @product.update product_params
            flash[:notice] = "Updated!"
            redirect_to show_product_path(@product)
        else
            render :edit
        end
    end

    private

    def product_params
        params.require(:product).permit(:title, :description, :price, :sales_price)
    end

    def find_product
        @product = Product.find params[:id]
    end

    def authorize
        redirect_to index_path, alert: "Not Authorized!" unless can?(:manage, @product) 
    end
end
