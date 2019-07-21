class ReviewsController < ApplicationController
    before_action :authenticate_user!
    def create
        @product = Product.find params[:product_id]
        # means: Product.find 1007 
        params_review = params.require(:review).permit(:body, :rating)
        @review = Review.new params_review

        # @reviews = @product.reviews # overwriting @ eview
        @review.product = @product # joins the table
        # parent product of @review is @product
        # i.e.
        # r = Review.find 8
        # r.Product prints out the product that's associated with r
        # and now I'm setting the result of the product db equal to the product with the id of product_id in line 3
        @review.user = current_user
        if @review.save
            flash[:notice] = "A new comment has been added!"
            # ReviewMailer.new_review(@review).deliver_now
            redirect_to show_product_path(@review.product_id) 
        else
            @reviews = @product.reviews.order(created_at: :desc)
            render 'products/show' # needs @product because it's not hitting the product_controller
        end
        # all instance variables are scoped to the  controllers
        # when you load the erb file, t hat's when those instance variables become available.

    end

    def destroy
        review =Review.find(params[:id])
        if can?(:crud, review)
            review.destroy
            redirect_to show_product_path(review.product_id), notice: "deleted!"
        else
            redirect_to show_product_path(review.product_id), alert: "Not Authorized!"
        end
    end


    def toggle_hidden
        @review =Review.find(params[:id])
        if !@review.hidden?
            @review.update(hidden: true)
        else
            @review.update(hidden: false)
        end
        redirect_to product_path(@review.product)
    end

    # def toggle_hidden
    #     # update the boolean field 'hidden' to whatever it isn't currently
    #     @review.update(hidden: !@review.hidden?)
    #     redirect_to product_path(@review.product), notice: "Review #{@review.hidden ? 'hidden' : 'shown'}."
    # end
end
