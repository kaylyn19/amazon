class SessionsController < ApplicationController
    def new
    end

    def create
        user = User.find_by_email params[:email]
        if user&.authenticate(params[:password])
            session[:user_id] = user.id
            redirect_to root_path, notice: "Signed In!"
        else
            flash[:alert] = "Check your email and password again."
            render :new
        end
    end

    def destroy
        session[:user_id] = nil
        redirect_to root_path, notice: "logged out!"
    end
end
