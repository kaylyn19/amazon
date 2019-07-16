class LikesController < ApplicationController
    before_action :authenticate_user!

    def create
        review = Review.find params[:review_id]
        product = Product.find params[:product_id]
        like = Like.new(review_id: review.id, user_id: current_user.id)
        
        if !can?(:like, review)
            return redirect_to show_product_path(product), alert: "You can't like your own comment!"
        end

        if like.save
            redirect_to show_product_path(product), notice: 'liked!'
        else
            redirect_to show_product_path(product)
        end
    end

    def destroy
        product = Product.find params[:product_id]
        review = Review.find params[:review_id]
        liker = Like.find params[:id]
        liker.destroy
        redirect_to show_product_path(product)
    end


end
