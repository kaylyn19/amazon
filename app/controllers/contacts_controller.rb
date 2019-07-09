class ContactsController < ApplicationController
    def new
    end

    def thank_you
        @name = params["name"]
        @email = params["email"]
        @message = params["message"]
    end

end
