class PostsController < ApplicationController
  #before_filter :authenticate_user!

  load_and_authorize_resource :post

  def index
  end

  def show
  end

  def new
    image = @post.images.build
  end

  def edit
  end

  def create
    if @post.save
      redirect_to @post, notice: 'Post was successfully created.'
    else
      #debugger
      render action: "new"
    end
  end

  def update
    if @post.update_attributes(params[:post])
      redirect_to @post, notice: 'Post was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_url, notice: 'Post was successfully destroyed.'
  end
end
