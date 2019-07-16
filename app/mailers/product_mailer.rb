class ProductMailer < ApplicationMailer
    def new_product(product)
        @product = product
        @product_owner = @product.user
        mail(
            to: @product_owner,
            subject: "#{@product.user.first_name}, your product is succesfully created"
        )
    end
end
