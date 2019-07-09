class AdministratorsController < ApplicationController
    def panel
        @admin = User.find session[:user_id]
        @products = Product.all.order(id: :asc)
        @reviews = Review.all
        @users = User.all
    end
end
