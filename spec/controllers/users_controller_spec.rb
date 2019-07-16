require 'rails_helper'

RSpec.describe UsersController, type: :controller do
    describe '#new' do
        it 'renders the new template' do
            get :new
            expect(response).to render_template :new
        end

        it 'sets an instance variable of user type' do
            get :new
            expect(assigns :user).to be_a_new(User)
        end
    end

    describe '#create' do
        context 'invalid parameters' do
            def invalid_params
                post :create, params: {user: FactoryBot.attributes_for(:user, last_name: nil)}
            end

            it 'renders the new page' do
                invalid_params
                expect(response).to render_template :new
            end

            it 'does not create a user in db' do
                count_before = User.count
                invalid_params
                count_after = User.count
                expect(count_after).to eq(count_before)
            end
        end

        context 'valid parameters' do
            def valid_params
                post :create, params: {user: FactoryBot.attributes_for(:user)}
            end

            it 'redirects to root path' do
                valid_params
                expect(response).to redirect_to root_path
            end

            it 'creates a new user in db' do
                count_before = User.count
                valid_params
                count_after = User.count
                expect(count_after).to eq(count_before + 1)
            end
        end
    end
end
