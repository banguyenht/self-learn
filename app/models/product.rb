class Product < ApplicationRecord
	has_many :categories
	has_one :discount
	has_many :images
end
