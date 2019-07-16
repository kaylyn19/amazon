require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validates' do
    it 'requires first name' do
      user = User.new(first_name: nil, last_name: 'kwak')
      user.valid?
      expect(user.errors.messages).to have_key :first_name
    end

    it 'requires last name' do
      user = User.new(first_name: 'kaylyn', last_name: nil)
      user.valid?
      expect(user.errors.messages).to have_key :last_name
    end

    it 'requires a unique email address' do
      persisted_user = FactoryBot.create(:user)
      new_user = User.new(first_name: 'kaylyn', last_name: 'kwak', email: persisted_user.email)
      new_user.valid?
      expect(new_user.errors.messages).to have_key :email
    end

    it 'returns titlelized full name' do
      user = FactoryBot.create(:user)
      full_name = "#{user.first_name} #{user.last_name}"
      expect(full_name).not_to eq(full_name.downcase)
    end
  end
end
