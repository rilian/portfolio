class HomeController < ApplicationController
  def index
    @categories = Category.all
  end

  def contacts

  end

  def about

  end
end
