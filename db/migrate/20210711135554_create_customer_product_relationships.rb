class CreateCustomerProductRelationships < ActiveRecord::Migration[6.0]
  def change
    create_table :customer_product_relationships do |t|
      t.integer :quantity
      t.references :product, null: false, foreign_key: true
      t.references :customer, null: false, foreign_key: true
    end

  end
end
