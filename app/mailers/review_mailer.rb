class ReviewMailer < ApplicationMailer
    # rails g mailer review_mailer
    def new_review(review)
        @review = review
        @product = @review.product
        @product_owned_by = @product.user
        mail(
            to: @product_owned_by,
            # from: current_user,
            subject: "#{@review.user.first_name} reviewed your product"
        )
    end
end
