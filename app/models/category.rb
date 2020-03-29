class Category < ApplicationRecord
	belongs_to :product, optional: true
end
