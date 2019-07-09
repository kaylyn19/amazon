class AddSalesPriceToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :sales_price, :float
  end
end
