class NewsArticlesController < ApplicationController
    before_action :authenticate_user!, except: [:show, :index]
    before_action :find_id, only: [:show, :destroy, :edit, :update]
    before_action :authorize, only: [:destroy, :edit, :update]

    def new
        @news_article = NewsArticle.new
    end

    def create
        @news_article = NewsArticle.new article_params
        @news_article.user = current_user
        if @news_article.save
            redirect_to news_article_path(@news_article.id)
        else
            render :new
        end
    end

    def show
        # @news_article = NewsArticle.find params[:id]
    end

    def destroy
        # @news_article = NewsArticle.find params[:id]
        @news_article.destroy
        flash[:notice] = 'destroyed!'
        redirect_to index_path
    end

    def index
        @news_article = NewsArticle.all.order(updated_at: :desc)
    end

    def edit
        # @news_article = NewsArticle.find params[:id]
    end

    def update
        # @news_article = NewsArticle.find params[:id]
        if @news_article.update article_params
            redirect_to @news_article
        else
            render :edit
        end
    end

    private

    def article_params
        params.require(:news_article).permit(:title, :description, :view_count, :published_at)
    end

    def find_id
        @news_article = NewsArticle.find params[:id]
    end

    def authorize
        redirect_to root_path, alert: 'not authorized' unless can?(:crud, @news_article)
    end

end
