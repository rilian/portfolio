class HomeController < ApplicationController
  def index
    @posts = Post.published
  end

  def contacts

  end

  def about

  end
end
