class VotesController < ApplicationController
    before_action :find_id
    before_action :authenticate_user!

    def create
        @vote = Vote.new(review_id: @review.id, user_id: current_user.id, upvote: params[:upvote])
        if can? :vote, @review
            if @vote.save
                redirect_to show_product_path(@review.product_id), success: "Thank you for voting!"
            else
                redirect_to show_product_path(@review.product_id), alert: "Unable to vote!"
            end
        else
            redirect_to show_product_path(@review.product_id), alert: "Cannot vote your own review"
        end
    end

    def update
        @vote = @review.votes.find_by(user_id: current_user.id)
        if can? :vote, @review
            if @vote.upvote == true
                @vote.update(upvote: false)
            else
                @vote.update(upvote: true)
            end
            redirect_to show_product_path(@review.product_id), success: "Thank you for voting!"
        else
            redirect_to show_product_path(@review.product_id), alert: "Cannot vote your own review"
        end
    end

    private

    def find_id
        @review = Review.find params[:review_id]
    end
end
