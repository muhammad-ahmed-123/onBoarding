class RemoveDescriptionfromproduct < ActiveRecord::Migration[8.1]
  def change
    remove_column :products, :description, :text
    remove_column :products, :price, :decimal
  end
end
