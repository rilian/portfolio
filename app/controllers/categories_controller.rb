class CategoriesController < ApplicationController
  #before_filter :authenticate_user!

  load_and_authorize_resource :category

  def show
    @posts = @category.posts.includes([:images]).page(params[:page])
  end
end
