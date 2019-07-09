class ChangePriceToBeFloatInProducts < ActiveRecord::Migration[5.2]
  def change
    # rails g migration change_price_to_be_float_in_products
    change_column :products, :price, :float
  end
end
