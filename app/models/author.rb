class Author < ApplicationRecord
	has_many :books
	accepts_nested_attributes_for :books, reject_if: proc { |attributes| attributes['title'].blank? }
	scope :with_available_books, -> { joins(:books).merge(Book.available) }
	scope :master, -> { where(master: true) }
end
