class Review < ApplicationRecord
  belongs_to :product
  belongs_to :user
  # .product
  # .product=(associate)
  # .build_product(attributes = {})
  # .create_product(attributes = {})
  # .create_product!(attributes = {})
  # .reload_product

  validates :rating, presence: {message: "must be given"}, numericality: {greater_than_or_equal_to: 1, less_than_or_equal_to: 5}
end
