class Product < ApplicationRecord
    belongs_to :user
    has_many(:reviews, dependent: :destroy)
    has_many :favourites, dependent: :destroy
    has_many :users, through: :favourites
    has_many :taggings, dependent: :destroy
    has_many :tags, through: :taggings
    # .reviews
    # .reviews<<(object, ...)
    # .reviews.delete(object, ...)
    # .reviews.destroy(object, ...)
    # .reviews=(objects)
    # .reviews_singular_ids
    # .reviews_singular_ids=(ids)
    # .reviews.clear
    # .reviews.empty?
    # .reviews.size
    # .reviews.find(...)
    # .reviews.where(...)
    # .reviews.exists?(...)
    # .reviews.build(attributes = {}, ...)
    # .reviews.create(attributes = {})
    # .reviews.create!(attributes = {})
    # .reviews.reload


    validates(:title, presence: true, uniqueness: {case_sensitive: false})
    validates(:description, presence: true, length: {minimum: 10})
    validates(:price, numericality: {greater_than: 0.00, less_than: 1000.00})
    validates(:sales_price, numericality: {less_than_or_equal_to: :price})

    # how to write validation of two columns in one line
    # validates :name, :price, presence:true, uniqueness: {case_sensitive:false}

    def hit # called on an instance
        # self.hit : called on a class
        increment!(:hit_count)
        # self class method
        # @ instance method
    end

    def self.price_range
        where("price > 100.0 AND price < 300.0").order('title asc').limit(5)
    end

    before_destroy(:before_destroy)
    before_validation(:set_default_price_to_1)
    before_validation(:set_deafult_hit_count_to_0)
    before_validation(:capitalize_product_title)
    after_initialize(:sales_price_equal_to_price)
    validate :reserved_name
    private

    def set_default_price_to_1
        self.price ||=1
    end

    def set_deafult_hit_count_to_0
        self.hit_count ||=0
    end

    def capitalize_product_title
        self.title = title.capitalize
    end

    def sales_price_equal_to_price
        self.sales_price ||=price
    end

    def before_destroy
        puts "Product is about to be deleted"
    end

    #custom validation
    scope(:search, -> (product) {where("title ILIKE ? OR description ILIKE ?", "%#{product}%", "%#{product}%")})
    
    def reserved_name
        if title&.downcase&.include?("apple")||title&.downcase&.include?("microsoft")||title&.downcase&.include?("sony")
            self.errors.add(:title, "Reserved Word!")
        end
    end



end

# update_attribute
# What does update_attribute do in ActiveRecord? Give an example. Should it be used or not?
# - update_attribute will change an attribute (user.update_attribute(:name, "Zaiste")) and persist but without running validations
# It shouldn't be used for the sake of the quality of data that you want to collect
