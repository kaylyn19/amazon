require 'rails_helper'

RSpec.describe NewsArticle, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  def news_article
    @article ||= NewsArticle.new({
      title: "news article title",
      description: 'descripton'
    }) 
  end

  describe "validates" do
    it('requires a title') do
      article = news_article
      #given
      article.title = nil
      #when
      article.valid?

      #then
      expect(article.errors.messages).to(have_key(:title))
    end

    it('requires a title to be unique') do
      persisted_article = FactoryBot.create(:news_article)
      user = FactoryBot.create(:user)
      article = NewsArticle.new(title: persisted_article.title, description: 'description', user: user)
      article.valid?
      expect(article.errors.messages).to(have_key :title)
    end

    it 'requires description' do
      article = news_article
      article.description = nil
      article.valid?
      expect(article.errors.messages).to have_key(:description)
    end

    it 'requires published_at to be after created_at' do
      date = Time.now
      user = FactoryBot.create(:user)
      article = NewsArticle.new(title: 'title', description: 'description', published_at: date, created_at: date, user: user)
      article.valid?
      expect(article.errors.full_messages).to include("Published at published at comes after created at")

      # answer from brett
      # n = news_article
      # n.save
      # n.published_at = n.created_at
      # n.valid?
      # expect(n.errors.messages).to have_key(:published_at) 
    end
  end
end
