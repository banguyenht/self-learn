class Discount < ApplicationRecord
	belongs_to :product, optional: true
	enum unit: { percent: 0, money: 1 }, _suffix: true
end
