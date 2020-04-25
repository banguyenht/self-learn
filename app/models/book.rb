class Book < ApplicationRecord
  belongs_to :author
  accepts_nested_attributes_for :author
  scope :available, -> { where(available: true) }
  scope :with_master_author, -> { joins(:author).merge(Author.master) }
end
