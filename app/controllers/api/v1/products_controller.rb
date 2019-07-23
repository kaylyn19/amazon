class Api::V1::ProductsController < Api::ApplicationController
    before_action :authenticate_user!, only: [:create, :destroy, :update]
    # rails g controller api/v1/products
    def index
        products = Product.order(created_at: :desc)
        render(json: products, each_serializer: ProductsCollectionSerializer)
    end

    def show
        product = Product.find params[:id]
        render json: product, include: [:seller, {reviews: [:seller]}]
        # render(json: products, each_serializer: ProductsCollectionSerializer)
        # ^ each_serializer only works for a collection of data
        # if you want to use it for a single data, e.g. show page, then just use serializer: <name-of-serializer>
    end

    def create
        product = Product.new product_params
        product.user = current_user
        if product.save
            render json: {id: product.id}
        else
            render json: {errors: product.errors}, status: 422
        end
    end

    def destroy
        product = Product.find params[:id]
        product.destroy
        render json: {status: 200}, status: 200
    end

    def update
        product = Product.find params[:id]
        if product.update product_params
            render json: {id: product.id}
        else
            render json: {errors: product.errors}, status: 422
        end
    end

    private

    def product_params
        params.require(:product).permit(:title, :description, :price)
    end
end
