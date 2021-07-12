class Product < ApplicationRecord
	validates :product_name, uniqueness: true
	has_many :customer_product_relationships
	has_many :customers, through: :customer_product_relationships
end
