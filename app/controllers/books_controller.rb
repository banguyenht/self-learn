class BooksController < ApplicationController
	def new
		@book = Book.new
		@author = @book.build_author
	end

	def create
		@book = Book.new(book_params)
		@book.save
	end

	private

	def book_params
		params.require(:book).permit(:title, author_attributes: [:id, :name])
	end
end
