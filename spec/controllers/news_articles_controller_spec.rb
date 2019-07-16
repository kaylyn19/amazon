require 'rails_helper'

RSpec.describe NewsArticlesController, type: :controller do
    def current_user
        @current_user ||= FactoryBot.create(:user)
    end

    describe '#new' do
        context 'with no user signed in' do
            it 'redirects to new_sessions_path' do
                get :new
                expect(response).to redirect_to(new_sessions_path)
            end

            it 'shows an alert message' do
                get :new
                expect(flash[:alert]).to be
            end
        end
        context 'with user signed in' do
            before do
                session[:user_id] = current_user.id
            end

            it "requires a new instance variable" do
                # given - default
                # when
                get(:new)
                # then
                expect(assigns(:news_article)).to be_a_new(NewsArticle)
            end

            it 'renders a new.html.erb file' do
                get(:new)
                expect(response).to render_template(:new)
            end
        end
    end

    describe '#create' do
        context 'with no user signed_in' do
            it 'redirects to the new_sessions_path' do
                post(:create, params: {news_article: FactoryBot.attributes_for(:news_article)})
                expect(response).to redirect_to(new_sessions_path)
            end
        end

        context 'with user signed_in' do
            before do
                session[:user_id] = current_user.id
            end
            context 'valid' do
                it 'redirects to the show page' do
                    post(:create, params: {news_article: FactoryBot.attributes_for(:news_article)})
                    expect(response).to redirect_to(news_article_path(NewsArticle.last))
                end

                it 'save works' do
                    before_save = NewsArticle.count
                    post(:create, params: {news_article: FactoryBot.attributes_for(:news_article)})
                    after_save = NewsArticle.count 
                    expect(after_save).to eq(before_save + 1)
                end

                it 'associates the user and the news article' do
                    post(:create, params: {news_article: FactoryBot.attributes_for(:news_article)})
                    expect(NewsArticle.last.user_id).to eq(current_user.id)
                end
            end

            context 'invalid' do
                it 'renders the create form' do
                    post(:create, params: {news_article: {title: nil, description: nil}})
                    expect(response).to render_template(:new)
                end
            end
        end
    end

    describe '#show' do
        def get_show
            @news_article = FactoryBot.create(:news_article)
            get(:show, params: {id: @news_article.id})
        end

        it 'renders the show page' do
            get_show
            # news_article = FactoryBot.create(:news_article)
            # get(:show, params: {id: news_article.id})
            expect(response).to render_template(:show)
        end

        it 'sets an instance variable with an id' do
            get_show
            # news_article = FactoryBot.create(:news_article)
            # get(:show, params: {id: news_article.id})
            id = NewsArticle.find_by(id: @news_article.id)
            expect(assigns(:news_article)).to eq(id)
        end
    end

    describe '#destroy' do
        context 'with no user signed in' do
            it 'redirects to new_sessions_path' do
                article = FactoryBot.create(:news_article)
                delete(:destroy, params: {id: article.id})
                expect(response).to redirect_to(new_sessions_path)
            end
        end

        context 'with user signed in' do
            before do
                session[:user_id] = current_user.id
            end
    
            context 'non-authorized user of the article' do
                before do
                    @news_article = FactoryBot.create(:news_article)
                    delete(:destroy, params: {id: @news_article.id})
                end

                it 'redirects to root_path' do
                    expect(response).to redirect_to(root_path)
                end

                it 'alerts the non-authorized user' do
                    expect(flash[:alert]).to be
                end

                it 'does not remove the post' do
                    expect(@news_article.id).to be
                end
            end

            context 'authorized user of the article' do
                before do
                    @news_article = FactoryBot.create(:news_article, user: current_user)
                    delete(:destroy, params: {id: @news_article.id})
                end

                it 'destroys the article' do
                    expect(NewsArticle.find_by(id: @news_article.id)).to eq(nil)
                end
                
                it 'flash message' do
                    expect(flash[:notice]).to be
                end

                it 'redirects to index_path after successful deletion' do
                    expect(response).to redirect_to(index_path) 
                end
            end
        end
    end

    describe '#index' do
        it 'displays all the articles in desc order by updated_at' do
            article_1 = FactoryBot.create(:news_article)
            article_2 = FactoryBot.create(:news_article)
            get(:index)
            expect(assigns :news_article).to eq([article_2, article_1])
        end

        it 'renders index page' do
            get :index
            expect(response).to render_template(:index)
        end
    end

    describe '#edit' do
        context 'with no user signed in' do
            it 'redirects to the sign in page' do
                article = FactoryBot.create(:news_article)
                get :edit, params: {id: article.id}
                expect(response).to redirect_to(new_sessions_path)
            end
        end

        context 'with user signed in' do
            before do
                session[:user_id] = current_user.id
            end

            context 'non-authorized user signed in' do
                before do
                    article = FactoryBot.create(:news_article)
                    get :edit, params: {id: article.id}
                end

                it 'redirects the user to the root path' do
                    expect(response).to redirect_to(root_path)
                end

                it 'flashes alert message' do
                    expect(flash[:alert]).to be
                end 
            end

            context 'authorized user signed in' do
                before do
                    article = FactoryBot.create(:news_article, user: current_user)
                    get(:edit, params: {id: article.id})
                end

                it 'render the edit page' do
                    expect(response).to render_template :edit
                end

                it 'instantiate a variable' do
                    expect(assigns :news_article).to be_a(NewsArticle)            
                end
            end
        end
    end

    describe '#update' do
        context 'with no user signed in' do
            it 'redirects to the sign in page' do
                article = FactoryBot.create(:news_article)
                put :update, params: {id: article.id, news_article: article}
                expect(response).to redirect_to(new_sessions_path)
            end
        end

        context 'with user signed in' do
            before do
                session[:user_id] = current_user.id
            end

            context 'non-authorized user' do
                before do
                    @article = FactoryBot.create(:news_article)
                    put :update, params: {id: @article.id, news_article: @article}
                end

                it 'redirect the user to the root path' do
                    expect(response).to redirect_to root_path
                end

                it 'flashes an alert message' do
                    expect(flash[:alert]).to be
                end
            end

            context 'authorized user' do                
                context 'valid update' do
                    it 'updates successfully and redirect to the show page' do
                        article = FactoryBot.create(:news_article, user: current_user)
                        put :update, params: {id: article.id, news_article: {title: 'updated'}}
                        expect(NewsArticle.find_by(id: article.id).title).to eq('updated')
                        expect(response).to redirect_to(news_article_path(article.id))
                    end
                end

                context 'invalid update' do
                    it 'renders the edit page' do
                        article = FactoryBot.create(:news_article, user: current_user)
                        put(:update, params: {id: article.id, news_article: {title: nil, description: nil}})
                        expect(response).to render_template(:edit)
                    end

                    it 'does not update the change' do
                        article = FactoryBot.create(:news_article, user: current_user)
                        put :update, params: {id: article.id, news_article: {title: 'updated', description: nil}}
                        expect(NewsArticle.find_by(id: article.id).title).not_to eq('updated')
                    end
                end
            end
        end
    end
end
