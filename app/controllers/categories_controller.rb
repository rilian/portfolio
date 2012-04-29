class CategoriesController < ApplicationController
  load_and_authorize_resource :category, :except => [:index, :show]
  load_resource :category, :only => [:index, :show]

  def index
    @categories = @categories.includes([:images])
  end

  def show
    @images = @category.images.page(params[:page]).per(10)
  end

  def create
    if @category.save
      redirect_to category_path(@category)
    else
      render :edit
    end
  end

  def edit
  end

  def update
    if @category.update_attributes(params[:category])
      redirect_to category_path(@category)
    else
      render :edit
    end
  end

  def new
  end

  def destroy
    @category.destroy
    redirect_to categories_path
  end
end