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
            ProductMailer.new_product(@product).deliver_later
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

         # In this case only the product owner will have all reviews available in the
        # through @reviews (including hidden reviews).
        # You could also remove this logic here and do some logic in the view. Your use case (and
        # for now, the size of your Rails toolset) will determine the best way to things.
        # We've done it this way because with the tools available to us it minimizes the
        # amount of repeated code and if else statements in our view.
        if can? :crud, @product
            @reviews = @product.reviews.order(created_at: :desc)
        else
            @reviews = @product.reviews.where(hidden: false).order(created_at: :desc)
        end
    end

    def index
        if params[:tag]
            @tag = Tag.find_by(name: params[:tag])
            @product = @tag.products.order(created_at: :desc)
        else
            @product = Product.all.order('created_at desc')
        end
    end

    def destroy
        flash[:notice] = "Product deleted!"
        # product = Product.find params[:id]
        @product.destroy
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
        params.require(:product).permit(:title, :description, :price, :sales_price, :tag_name)#, {tag_ids: []})
    end

    def find_product
        @product = Product.find params[:id]
    end

    def authorize
        redirect_to index_path, alert: "Not Authorized!" unless can?(:crud, @product) 
    end
end
