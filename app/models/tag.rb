class Tag < ApplicationRecord
    has_many :taggings, dependent: :destroy
    has_many :products, through: :tagging

    validates :name, uniqueness: {case_sensitive: false}
end
