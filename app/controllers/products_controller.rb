class ProductsController < ApplicationController
	respond_to :html, :js
	def index
		@a = 'a'
	end

	def test
		respond_to do |format|
			format.html
			format.json do
				render json: {
					data: render_to_string(partial: 'layouts/_header')
				}
			end
		end
	end

	def show
		
	end
end
