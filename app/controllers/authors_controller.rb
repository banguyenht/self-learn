class AuthorsController < ApplicationController
	def new
		@author = Author.new
		@author.books.build
	end

	def create
		@author = Author.new(author_params)
		@author.save
	end

	def show
		@authors = Author.all.includes(:books)
	end

	private

	def author_params
		params.require(:author).permit(:name, :age, books_attributes: [:id, :title])
	end
end
