class Customer < ApplicationRecord
	validates :email, uniqueness: true
	has_many :customer_product_relationships
	has_many :products, through: :customer_product_relationships
end
