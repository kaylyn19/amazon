class FavouritesController < ApplicationController
    before_action :authenticate_user!

    def create
        @product = Product.find params[:product_id]
        @favourite = Favourite.new(user_id: current_user.id, product_id: @product.id)
        
        if can?(:favourite, @product)
            if @favourite.save
                redirect_to product_path(@product), notice: "Added to favourites"
            else
                redirect_to product_path(@product), alert: "Unable to add the item to the favourites"
            end
        else
            redirect_to product_path(@product), notice: "You can add your own item to the favourite"
        end
    end

    def destroy
        product = Product.find params[:product_id]
        if can? :favourite, product
            product.favourites.find_by(user: current_user).destroy
            redirect_to product_path(product), notice: "Un-favourite"
        else
            redirect_to product_path(product), notice: "Error! Unable to un-favourite"
        end
    end
end
