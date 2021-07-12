class CustomerProductRelationship < ApplicationRecord
  belongs_to :product
  belongs_to :customer

  validates :quantity, uniqueness: { scope: [:product_id, :customer_id] }
end
