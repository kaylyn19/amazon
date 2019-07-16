class NewsArticle < ApplicationRecord
    belongs_to :user
    validates :title, presence:true, uniqueness: true
    validates :description, presence: true

    validate :newer_published_at
    # before_validation :default_published_date
    before_validation(:newer_published_at)
    after_save(:titleize)

    scope(:articles_published_after_current_date, -> (published_at) {where('published_at > created_at').order(published_at: :desc)})

    def publish
        update(published_at: Time.zone.now)
    end

    def titleize
        self.title = title.titleize
    end


    # brett's answer
    # scope :published, -> { where( 'published_at > created_at' ) }

    private
    # custom validation
    def newer_published_at
        return unless published_at.present?
        self.errors.add(:published_at, "published at comes after created at") unless published_at > created_at
    end
end
