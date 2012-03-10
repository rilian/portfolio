class CategoriesController < ApplicationController
  #before_filter :authenticate_user!

  load_and_authorize_resource :category

  def show
    @category = Category.find params[:id]
    @posts = Post.where(:category_id => @category.id).published
  end
end
